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
1. First, we need to enable Internet Sharing on OS X so launch 'System Preferences'
2. Click 'Sharing'
3. Select 'Internet Sharing' in the sidebar
4. Under 'Share your connection from:' select 'Ethernet'
5. In the box labelled 'To computers using:' select Wi-Fi
6. Enable Internet Sharing by selecting the checkbox next to it on the left.
7. You're now broadcasting a network! Yay! XZone will handle everything else from here. Just follow these instructions whenever you need to enable or disable Internet Sharing.

###### Downloading and Executing XZone:
Previously, there were two scripts you could download but these have both been combined in to one utility now. By default, XZone runs as verbose (meaning it outputs what it is doing to the Terminal window), but you can also silence it if you don't want to see it running. Don't worry, in a future version we will have XZone running as a daemon so we won't need a terminal window open! Yesssssss!

To enable your HomePass network, download and extract the zip of the repository (which you can find to the right of this ReadMe), open Terminal, and simply drag XZone on to the window and hit return. If Terminal complains about permissions, you might need to first run `chmod +x \path\to\XZone`, of course inserting the correct path to your XZone file. You'll then be asked for an administrator password (because some of the functions require elevated privileges) so make sure you have admin rights before running this.

You can see what launch options are available by running XZone with the `-h` flag. (i.e. `./XZone -h`)

###### Initial Setup
The first time you run XZone, you'll be asked a few setup questions in order to configure it for your preference. First, decide whether or not you want to use the Nintendo World MACs when cycling. If you choose to, XZone will automagically spoof them and the correct SSID every time it exhausts the 255 HomePass MACs.

Next, choose how often you want XZone to cycle (refresh) the MAC address, the default being every two minutes. Why would you want to change this, you might ask? If you want to play a game that requires an internet connection for an extended duration (such as Pokémon, for example) you'll need to stop XZone from cycling every n minutes and disrupting your internet connectivity. When prompted, input the cycle frequency you want to use, in minutes. If you input a value less than 2, it will automatically default to two minutes to prevent any problems from occurring. (In a future patch, "0" will be a viable option too, if you wish to disable cycling for whatever reason.)

Then, select the SSID you want to use. Initially, you are presented with only the two default choices that most people are using ('attwifi' and 'NZ@McD1'), but you can choose to see the entire list and select another if you have a specific reason to.

Finally, you can choose to set the final octet of the HomePass MAC that you want to start at. This is entirely optional, but useful if you've reset your preferences for some reason or another and need to start at a specific MAC to avoid the 3DS cooldown time.

And that's it. Your HomePass (let's call it XZone, though, yeah?) is set up and running. Woohoo! Just sit back and watch as all the StreetPass data comes flooding in! On subsequent launches, XZone will use your preset preferences and pick up where it left off, so you won't need to go through the above steps again unless you choose to reset your preferences.

###### Stopping XZone:
Stopping XZone is simple; You can simply hit Ctrl+C to terminate the script. XZone will then revert all changes to your system that it has made and close.

<hr>

#### How it works:
To get a better idea of how XZone works, open it up in a text editor and glance through the (generally over-commented) code. Or, if you're lazy, here's a little summary.

XZone works by automatically setting the MAC address of your WiFi card to one in a preset range that has been chosen for HomePass, and broadcasting a wireless network with an SSID (or name) that the 3DS recognises as an open, safe network to use.
When your 3DS connects, it talks to Nintendo's StreetPass servers in order to download information about other 3DS users connected to the same SSID, exchanging any data between the devices necessary for Spot/StreetPass functionality in your games (like Miis in Mii Plaza).
Normally, the 3DS caches a MAC address for about 8 hours, preventing you from spamming your friends with StreetPass data. To get around this, XZone cycles through MAC addresses every so often, fooling the 3DS in to thinking it is connecting to a different device and thus connecting and downloading data again.

The SSID you choose is entirely up to you. There is a list of usable SSIDS available [here](http://yls8.mtheall.com/ninupdates/3ds_nzonehotspots.php?version=v15360) that shows you which SSIDS the 3DS will automatically connect to and their respective functionality. The most common is 'NZ@McD1', so you'll likely get the most hits on that. The second most common is 'attwifi', which differs from 'NZ@McD1' in that it no longer functions as a Nintendo Zone (see the post [here](https://gbatemp.net/threads/how-to-have-a-homemade-streetpass-relay.352645/page-269#post-5401283) for an explanation) but still functions as a StreetPass relay.

<hr>

#### Thanks
There are actually far too many people to thank here for their inspiration in creating XZone. Most notably, the entire 3DS homebrew team who are probably the reason we know how this all works in the first place. [taintedzodiac](https://github.com/taintedzodiac), without whom I wouldn't have had [relaymyhome](https://github.com/taintedzodiac/relaymyhome) to pull apart and learn bash scripting from. Also, far too many users on StackExchange whose questions and answers realy helped me out when I was pulling my hair out trying to figure out how to do something. [FatMagic](http://reddit.com/u/FatMagic) for his spreadsheet [here](https://docs.google.com/spreadsheet/ccc?key=0AvvH5W4E2lIwdEFCUkxrM085ZGp0UkZlenp6SkJablE#gid=0). And of course, all the guys and girls at GBATemp, particularly [this thread](https://gbatemp.net/threads/how-to-have-a-homemade-streetpass-relay.352645/), who've helped out the community with NZone for Windows, Linux, and DD-WRT.

#### Want to say thanks?
XZone is built and maintained by me in my spare time as a bit of a hobby, and a way for me to carry on learning to code while having fun. Obviously, I'm not getting paid for it, and I don't expect to. But if you're feeling like saying thanks, you can give me a shoutout on [Twitter](http://twitter.com/stuhonour) and spread the word with #XZoneApp. Or, for the more generous among you, you could donate via BitCoin (1JcQvD9gr2xncU9cb9ZEPWRkJiFd8CUwEJ) or [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=6TXLBUS62DEDU&lc=ZA&item_name=XZone&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted). :)

