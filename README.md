# cloud-link
**A PowerShell script for quick-and-easy symlinking local folders to cloud drives (or anywhere else).**

It amazes me how many inconveniences can be solved with symbolic links. Equally as amazing is how under-utilized they are in Windows despite being a part of the OS since Windows 2000. Many people still don't even realize they exist!

I've written a lot of scripts over the years for managing symbolic links of different kinds for different purposes, but I find that a few common reasons for all of them emerge:

* Cloud storage for backups
* Cloud storage for synchronizing with other devices
* Secondary hard drives for saving space

"Cloud storage" wins two out of three, so I decided to focus Cloud Link on that particular purpose, but it also handles the third (and many other use-cases) just fine.

My goal was to create something **user-friendly enough** that anyone can use it *even if they don't particularly understand what it does*. As such, Cloud Link uses PowerShell forms to provide a GUI for selecting folders and displaying important information. It also requires no installation, unlike some other symlink frontends out there.

But the real charm of Cloud Link is that it uses "reverse symlinking". That is, files are *moved* to the destination, then symlinked back to the source. This is useful in all kinds of situations, and with Cloud Link, it 'just works'.

Of course, if you ever decide symlinking isn't for you, Cloud Link can also **non-destructively** disconnect any links it creates. If you've sync'd data to other devices through a cloud drive, those files stay in the cloud and continue syncing to other devices.

# How-to:
Download `cloud-link.ps1` and run it. Anywhere is fine.

Cloud Link has three modes of operation which will allow you to: 

* 1 - Upload files to a new link
* 2 - Download files from an existing link
* 3 - Disconnect from an existing link

Enter the number corresponding to the task you want, and follow the prompts while Cloud Link does the rest.

That's it!
