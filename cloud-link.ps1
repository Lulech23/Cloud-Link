<#
INITIALIZATION
#>

<# Initialize version #>
$Version = "1.0"

<# Initialize checking user elevation status #>
$UserIsAdmin = ([Security.Principal.WindowsPrincipal] `
[Security.Principal.WindowsIdentity]::GetCurrent() `
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

<# Initialize folder selector #>
function Get-Folder($WindowDescription) {
    <# Initialize form #>
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $FolderName = New-Object System.Windows.Forms.FolderBrowserDialog

    <# Set form properties #>
    $FolderName.Description = $WindowDescription
    $FolderName.SelectedPath = $Env:APPDATA

    <# Show form on top of other windows #>
    $OnTop = New-Object System.Windows.Forms.Form
    $OnTop.TopMost = $true

    <# Get folder from selection form #>
    if ($FolderName.ShowDialog($OnTop) -eq "OK") {
        $Folder += $FolderName.SelectedPath
    } else {
        <# Otherwise return 'cancel' if no folder was selected #>
        $Folder = "CANCEL"
    }

    <# Return selected folder #>
    return $Folder
}

<# Initialize warning popup #>
function Get-Confirm($WindowDescription) {
    $Confirm = [System.Windows.Forms.MessageBox]::Show("$WindowDescription" , "Warning!" , 4)

    return $Confirm
}


<#
CHOOSE LINK OPERATION
#>

<# Show title #>
Write-Host "`n`<`< Cloud Link by Lulech23 (v$Version) `>`>" -ForegroundColor DarkCyan

<# Show warning if script not run as admin #>
if ($UserIsAdmin -eq $false) {
    Write-Host "`nWarning: PowerShell not running as administrator. Some operations may not function as expected." -ForegroundColor Red
    Write-Host "(If Windows is running in Developer Mode, you can ignore this message.)" -ForegroundColor Red
}

<# Get task #>
Write-Host "`nChoose a task to perform:" -ForegroundColor Yellow
Write-Host "   1 - Create new link (upload)`n   2 - Connect to link (download)`n   3 - Disconnect from link`n   4 - Cancel"
$TargetTask = read-host [Enter Selection]

<# Clamp selection to acceptable values #>
if ($TargetTask -lt 1) {
    $TargetTask = 1
}
    
if ($TargetTask -gt 4) {
    $TargetTask = 4
}


<#
PERFORM LINK OPERATIONS
#>

<# Create new link (Upload) #>
if ($TargetTask -eq 1) {
    <# Get source folder #>
    Write-Host "`nChoose a local folder to upload..." -ForegroundColor Yellow
    $SourcePath = Get-Folder("Select local folder to upload")

    <# If source folder is selected... #>
    if ($SourcePath -ne "CANCEL") {
        Write-Host "[Enter Selection]: `"$SourcePath`""

        <# Get target folder #>
        Write-Host "`nChoose a target cloud folder for linked data..." -ForegroundColor Yellow
        $TargetPath = Get-Folder("Select target cloud folder")

        <# If target folder is selected... #>
        if ($TargetPath -ne "CANCEL") {
            Write-Host "[Enter Selection]: `"$TargetPath`""

            <# Show warning #>
            $WarningText = "`nAny existing cloud data in the destination folder will be OVERWRITTEN with the local copy. Are you sure?"
            $WarningResponse = Get-Confirm("$WarningText")
            Write-Host "$WarningText (Y/N)" -ForegroundColor Red
            Write-Host "[Enter Selection]:"("$WarningResponse").Substring(0, 1)

            <# Upload data, if confirmed #>
            if ($WarningResponse -eq "YES") {
                Write-Host "`nProcessing files. Please wait..." -ForegroundColor Yellow
                Write-Host "`"$SourcePath`" ==> `"$TargetPath`""

                <# Copy data to cloud folder #>
                Copy-Item "$SourcePath\*" -Destination "$TargetPath" -Recurse

                <# Delete local folder #>
                Remove-Item "$SourcePath" -Recurse

                <# Create symbolic folder link #>
                New-Item -ItemType Junction -Path "$SourcePath" -Target "$TargetPath"

                <# End operation successfully #>
                $TargetTask = 5
            } else {
                <# Otherwise, cancel operation #>
                $TargetTask = 4
            }
        } else {
            <# Otherwise, cancel operation #>
            $TargetTask = 4
        }
    } else {
        <# Otherwise, cancel operation #>
        $TargetTask = 4
    }
}


<# Connect to existing link (Download) #>
if ($TargetTask -eq 2) {
    <# Get source folder #>
    Write-Host "`nChoose a cloud folder to connect..." -ForegroundColor Yellow
    $SourcePath = Get-Folder("Select cloud folder to connect")

    <# If source folder is selected... #>
    if ($SourcePath -ne "CANCEL") {
        Write-Host "[Enter Selection]: `"$SourcePath`""

        <# Get target folder #>
        Write-Host "`nChoose a target local folder for linked data..." -ForegroundColor Yellow
        $TargetPath = Get-Folder("Select target local folder")

        <# If target folder is selected... #>
        if ($TargetPath -ne "CANCEL") {
            Write-Host "[Enter Selection]: `"$TargetPath`""

            <# Show warning #>
            $WarningText = "`nAny existing local data in the destination folder will be OVERWRITTEN with the cloud copy. Are you sure?"
            $WarningResponse = Get-Confirm("$WarningText")
            Write-Host "$WarningText (Y/N)" -ForegroundColor Red
            Write-Host "[Enter Selection]:"("$WarningResponse").Substring(0, 1)

            <# Download data, if confirmed #>
            if ($WarningResponse -eq "YES") {
                Write-Host "`nProcessing files. Please wait..." -ForegroundColor Yellow
                Write-Host "`"$SourcePath`" ==> `"$TargetPath`""

                <# Delete local folder #>
                Remove-Item "$TargetPath" -Recurse

                <# Create symbolic folder link #>
                New-Item -ItemType Junction -Path "$TargetPath" -Target "$SourcePath"

                <# End operation successfully #>
                $TargetTask = 5
            } else {
                <# Otherwise, cancel operation #>
                $TargetTask = 4
            }
        } else {
            <# Otherwise, cancel operation #>
            $TargetTask = 4
        }
    } else {
        <# Otherwise, cancel operation #>
        $TargetTask = 4
    }
}

<# Disconnect from Link #>
if ($TargetTask -eq 3) {
    <# Get source folder #>
    Write-Host "`nChoose a local linked folder to disconnect..." -ForegroundColor Yellow
    $SourcePath = Get-Folder("Select local folder to disconnect")

    <# If source folder is selected... #>
    if ($SourcePath -ne "CANCEL") {
        Write-Host "[Enter Selection]: `"$SourcePath`""

        <# Get target folder #>
        Write-Host "`nChoose a target cloud folder for linked data..." -ForegroundColor Yellow
        $TempPath = Get-Location
        Set-Location -Path (Split-Path -Path "$SourcePath" -Parent)
        $TargetPath = Get-ChildItem . (Split-Path -Path "$SourcePath" -Leaf) | ForEach-Object {$_.target}
        Set-Location -Path $TempPath

        <# If target folder is a symlink... #>
        if ($null -ne $TargetPath) {
            Write-Host "[Detected link path]: `"$TargetPath`""

            <# Show warning #>
            $WarningText = "`nAny existing cloud data will be downloaded and unlinked from the local copy. Other linked devices will not be affected. Are you sure?"
            $WarningResponse = Get-Confirm("$WarningText")
            Write-Host "$WarningText (Y/N)" -ForegroundColor Red
            Write-Host "[Enter Selection]:"("$WarningResponse").Substring(0, 1)

            <# Download data and unlink, if confirmed #>
            if ($WarningResponse -eq "YES") {
                Write-Host "`nProcessing files. Please wait..." -ForegroundColor Yellow
                Write-Host "`"$TargetPath`" ==> `"$SourcePath`""

                <# Delete local folder #>
                Remove-Item "$SourcePath" -Recurse -Force

                <# Copy cloud contents to local folder #>
                Copy-Item "$TargetPath" -Destination "$SourcePath" -Recurse

                <# End operation successfully #>
                $TargetTask = 5
            } else {
                <# Otherwise, cancel operation #>
                $TargetTask = 4
            }
        } else {
            <# Otherwise, cancel operation #>
            Write-Host "`nError: Selected folder is not linked. Nothing to do here." -ForegroundColor Red
            $TargetTask = 4
        }
    } else {
        <# Otherwise, cancel operation #>
        $TargetTask = 4
    }
}

<# Cancel operation #>
if ($TargetTask -eq 4) {
    Write-Host "`nOperation cancelled." -ForegroundColor Red
}

<# Complete operation #>
if ($TargetTask -eq 5) {
    Write-Host "`nOperation completed successfully. You do not need to run this script again for changes to persist." -ForegroundColor Yellow
}

Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')