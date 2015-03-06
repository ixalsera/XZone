# XZone
XZone (pronounced ten-zone) is a small command line utility to create and maintain a Nintendo Zone from your Mac, allowing you to receive StreetPass data without actually being on the street.
#### Why?
Not all of us are lucky enough to live in an area where you easily come across other DS users. Maybe you live in the countryside, maybe all your friends are losers with PSPs or LeapPads, or maybe you live in a country where there simply isn't that large a Nintendo market. How then would you get to use the awesome features of your DS that require StreetPass data? Simple, set up a HomePass network!
#### And why XZone?
There is already a utility available for Windows and Linux users called NZone that can set up and maintain a Nintendo Zone network, but until now OS X users have had to manually sort everything out themselves, which kind of goes against the Mac ethos. XZone aims to remedy that and (eventually) provide a simple solution to create and maintain a Nintendo Zone from a Mac.
The "X" in "OS X" is actually pronounced "ten" and not "ex", and since we are basically doing the same as NZone on OS X, why not teNZone, or XZone? Geddit? Goddit? Good!

<hr>

## Configuration:
###### How to set up your network:
1. First, we need to configure the built in Internet Sharing options available on OS X so launch 'System Preferences'
2. Click 'Sharing'
3. Select 'Internet Sharing' in the sidebar
4. Under 'Share your connection from:' select 'Ethernet'
5. In the box labelled 'To computers using:' select Wi-Fi
6. Click 'Wi-Fi Options...'
7. In the 'Network Name' box, type the SSID of the Nintendo Zone you wish to use. A list of available SSIDs can be found [here](http://yls8.mtheall.com/ninupdates/3ds_nzonehotspots.php?version=v15360). Make sure you select an SSID with a SecurityMode set to 0 so that you have internet access.
8. If you know the channel of any other Wi-Fi devices around, set the channel of your Zone to the best available channel, otherwise leave it as it is.
9. Make sure 'Security' is set to 'None'.
10. Click 'Ok' and enable Internet Sharing by selecting the checkbox next to it on the left.
11. Your network is now set up! Yay! You should only need to do this once (unless you frequently use Internet Sharing and need to change the information again!).

###### Enabling HomePass:
You have a choice of two files to download, `xzone.sh` and `xzone-v.sh`. Both of these files are exactly the same but for one exception: `xzone-v.sh` is a verbose version of the script, it will tell you exactly what it is doing at each step of the way. You can use this if a blank terminal window scares you a little. Don't worry, in a future version we will have these scripts running as a daemon so we won't need a terminal window open! Yesssssss!

To enable your HomePass network, download the zip of the repository (which you can find to the right of this ReadMe), open Terminal, and simply drag the script you want to use on to the window and hit return. It will ask you for an administrator password (because some of the functions require elevated privileges) so make sure you have admin rights before running this.

From version 0.2 you can choose how often you want XZone to cycle (refresh) the MAC address, the default being every two minutes. Why would you want to change this, you might ask? If you want to play a game that requires an internet connection for an extended duration (such as Pokémon, for example) you'll need to stop XZone from cycling every two minutes and disrupting your internet connectivity. When prompted, input the cycle frequency you want to use, in minutes. If you input a value less than 2, it will automatically default to two minutes to prevent any problems from occurring.

And that's it. Your HomePass (let's call it XZone, though, yeah?) is set up and running! Woohoo! Just sit back and watch as all the StreetPass data comes flooding in.

###### Stopping XZone:
Stopping XZone is simple. You can either click the red traffic light to close the Terminal window (Terminal will double check that you want to quit all running processes, just say yes) or you can hit Ctrl+C to terminate the script.

<hr>

#### How it works:
More info will be available here shortly.
