# cloud-link
**A PowerShell script for quick-and-easy symlinking local folders to cloud drives (or anywhere else).**

It amazes me how many inconveniences can be solved with symbolic links. Equally as amazing is how under-utilized they are in Windows despite being a part of the OS for 20 years. Many people still don't even realize they exist!

If that includes you, fear not. All you need to know is that you can move your files wherever you want *without your PC even knowing the difference*. Want to keep programs on your C drive, but you're running low on space? Symlink big files to another hard drive. Want to synchronize game save files across devices? Symlink them to the cloud. Yep, it's pretty handy.

# About
> *Store any files anywhere and sync with anything. Your apps won't know the difference. Just the way it should be.*

I've written a lot of scripts over the years for managing symbolic links of different kinds for different purposes, but I find that a few common reasons for all of them emerge:

* Cloud storage for backups
* Cloud storage for synchronizing with other devices
* Secondary hard drives for saving space

"Cloud storage" wins two out of three, so I decided to focus Cloud Link on that particular purpose, but it also handles the third (and many other use-cases) just fine.

![Screenshot](https://github.com/Lulech23/cloud-link/blob/master/screenshot.png)

My goal was to create something **user-friendly enough** that anyone can use it *even if they don't particularly understand what it does*. As such, Cloud Link uses PowerShell forms to provide a GUI for selecting folders and displaying important information. It also requires no installation, unlike some other symlink frontends out there.

But the real charm of Cloud Link is that it uses "reverse symlinking". That is, files are *moved* to the destination, then symlinked back to the source. This is useful in all kinds of situations, and with Cloud Link, it 'just works'.

Of course, if you ever decide symlinking isn't for you, Cloud Link can also **non-destructively** disconnect any links it creates. If you've sync'd data to other devices through a cloud drive, those files stay in the cloud and continue syncing to other devices.

# How-to:
If you've never run a PowerShell script before, you'll first need to enable running scripts (you only need to do this once). Run PowerShell as Administrator and paste the following command:

`Set-ExecutionPolicy RemoteSigned`

If all goes well, no messages will appear after setting the execution policy. No news is good news, as they say.

Next, **[download cloud-link.ps1](https://github.com/Lulech23/cloud-link/raw/master/cloud-link.ps1)** *(Right-click, Save As...)* 

Save it anywhere you like and run it.

> NOTE: You will either need to run PowerShell as Administrator or enable Developer Mode in Windows 10 Settings to use all features of Cloud Link

Cloud Link has three modes of operation which will allow you to: 

* 1 - Upload files to a new link
* 2 - Download files from an existing link
* 3 - Disconnect from an existing link

Enter the number corresponding to the task you want, and follow the prompts while Cloud Link does the rest.

That's it!
