#!/bin/bash
#
#
#		#############################################################
#		#															#
#		#	XZone Bash Script 0.4 - Scytheri0n						#
#		#															#
#		#	A simple bash script to create a HomePass network		#
#		#	on OS X.												#
#		#															#
#		#############################################################
#
#	Changelog:
#
#	0.4		-	Improved Nintendo World function to ensure that "attwifi" SSID is used. 
#				Added SSIDs to allow for selecting SSID to spoof at start. Backs up
#				current IS config to allow user to revert on exit.
#
#	0.3		-	Corrected script to not mistakenly warn that 2 minutes is too low
#				a cycle rate as well as corrected skipping of "ff" MAC. Included Nintendo #				World MACs. Allowed starting from custom MAC increment. Cleaned up script.
#
#	0.2		-	Allow user to enter a custom cycle rate
#
#	0.1		-	Initial release.
#
########################################################################################

#										Variables

########################################################################################

MAC="4e:53:50:4f:4f:"					#	The initial 5 octets of the MAC
endHex=00								#	The 6th octet for the MAC
count=0									#	Loop count
finalMAC=""								#	The final MAC address that will be spoofed
sleepTime=120							#	How long the script must pause for
includeNW=0								#	Nintendo World MACs included or not
isFirstPass=1							#	Is the script running again?

#	The original MAC address of the system
originalMAC=$(networksetup -getmacaddress Wi-Fi | awk '{print $3}')

########################################################################################

#											SSIDs
#
#	The following SSIDs have been extracted from
#	http://yls8.mtheall.com/ninupdates/3ds_nzonehotspots.php?version=v15360
#	and converted to hex in order to spoof the SSID using Internet Sharing.
#	I did not extract these SSIDs from the 3DS firmware and take no credit 
#	for that; all credit is directed to whomever did the extraction (let me
#	know if it was you and I will credit you appropriately!)
#
#	SSIDs are divided in to AP Name clusters with the SSID on the right and 
#	the corresponding hex value on the left.
#

########################################################################################

#	AT&T WiFi Services
ssid[01]="61747477696669"									#	attwifi
ssid[02]="4d63446f6e616c647320467265652057694669"			#	McDonalds Free WiFi

#	McDonald's Germany
ssid[03]="4e5a404d634431"									#	NZ@McD1
ssid[04]="4e5a404d634432"									#	NZ@McD2

#	Wifine
ssid[05]="776966696e65"										#	wifine

#	FreeSpot
ssid[06]="4652454553504f54"									#	FREESPOT


#	NOA Internal
ssid[07]="6e6f6173703031"									#	noasp1
ssid[08]="6e6f6173703032"									#	noasp2

#	Boingo Wireless
ssid[09]="426f696e676f20486f7473706f74"						#	Boingo Hotspot
ssid[10]="626f696e676f20686f7473706f74"						#	boingo hotspot
ssid[11]="41544c2d57692d4669"								#	ATL-Wi-Fi
ssid[12]="546f726f6e746f2050656172736f6e2057692d4669"		#	Toronto Pearson Wi-Fi
ssid[13]="4157472d57694669"									#	AWG-WiFi
ssid[14]="434c544e4554"										#	CLTNET
ssid[15]="494e445f5055424c49435f57694669"					#	IND_PUBLIC_WiFi
ssid[16]="4c41582d57694669"									#	LAX-WiFi
ssid[17]="4d49412d57694669"									#	MIA-WiFi
ssid[18]="5244555f57694669"									#	RDU_WiFi
#	San.Diego.Airport.Free.WIFI
ssid[19]="53616e2e446965676f2e416972706f72742e467265652e57494649"	
ssid[20]="666c7973616372616d656e746f"						#	flysacramento

#	Bell Mobility
ssid[21]="686f7473706f745f42656c6c"							#	hotspot_Bell
ssid[22]="42454c4c57494649404d43444f4e414c4453"				#	BELLWIFI@MCDONALDS
#	Boulevard Saint-Laurent WIFI
ssid[23]="426f756c6576617264205361696e742d4c617572656e742057494649"

#	Nintendo
ssid[24]="4e696e74656e646f53706f745061737331"				#	NintendoSpotPass1
ssid[25]="4e696e74656e646f53706f745061737332"				#	NintendoSpotPass2

#	McDonald's Italy
ssid[26]="4e696e74656e646f5f5a6f6e6531"						#	Nintendo_Zone1

#	Guglielmo
ssid[27]="4775676c69656c6d6f"								#	Guglielmo
ssid[28]="4775676c69656c6d6f5f4575726f6e696373"				#	Guglielmo_Euronics

#	KPN
ssid[29]="4b504e"											#	KPN

#	Meteor
ssid[30]="4d4554454f52"										#	METEOR
ssid[31]="4d43444f4e414c4453"								#	MCDONALDS
ssid[32]="434153494e4f5f62795f4d4554454f52"					#	CASINO_by_METEOR

#	The Cloud
ssid[33]="57694669205a6f6e65202d2054686520436c6f7564"		#	WiFi Zone - The Cloud
ssid[34]="6d79636c6f7564"									#	mycloud
ssid[35]="574c414e205a6f6e65202d2054686520436c6f7564"		#	WLAN Zone - The Cloud
ssid[36]="6d79636c6f756420436974792057694669"				#	mycloud City WiFi
ssid[37]="5f54686520436c6f7564"								#	_The Cloud

#	FreeHotspot.com
ssid[38]="667265652d686f7473706f742e636f6d"					#	free-hotspot.com
ssid[39]="686f7473706f742d677261747569742e636f6d"			#	hotspot-gratuit.com
ssid[40]="4175746f6772696c6c5f467265655f57694669"			#	Autogrill_Free_WiFi
ssid[41]="4175746f6772696c6c20467265652057694669"			#	Autogrill Free WiFi
ssid[42]="517569636b2057694669"								#	Quick WiFi
ssid[43]="517569636b2057692d4669"							#	Quick Wi-Fi
ssid[44]="517569636b5f57694669"								#	Quick_WiFi

#	O2 Wi-Fi
ssid[45]="4f322057696669"									#	O2 Wifi

#	Gowex Paris
ssid[46]="474f57455820465245452057694669"					#	GOWEX FREE WiFi

########################################################################################

#									Function Declarations

########################################################################################

function testForInteger {				#	Makes sure $inputTime is an integer
	re='^[0-9]+$'
	if ! [[ $inputTime =~ $re ]] ; then
 	  echo "You did not enter a valid number. Please try again."
 	  printf "Please enter the time (in minutes) you wish the script\nto cycle through addresses:  "
 	  read inputTime
 	  testForInteger
	fi
}

function testForHex {					#	Makes sure $startPoint is a valid octet
	case $startPoint in
	  ( "" )
        printf "Starting at "$MAC$endHex"\n"
        ;;
      ( *[!0-9A-Fa-f]* ) 
      	echo "Not a valid hex value"
      	printf "If you would like to start at a specific MAC, enter the final\n2-digit hex value (octet) here. (This is useful if you have terminated\nthe script and wish to pick up where you left off) Otherwise, just hit return.\n"
      	read startPoint
      	testForHex
      	;;
      ( * )                
        case ${#startPoint} in
        2)
        	endHex=$startPoint
        	endHex=$((0x${endHex}))
        	printf "Starting at "$MAC$startPoint"\n"
        	;;
        *)
        	echo "Please make sure the value is two digits exactly."
      		printf "If you would like to start at a specific MAC, enter the final\n2-digit hex value (octet) here. (This is useful if you have terminated\nthe script and wish to pick up where you left off) Otherwise, just hit return.\n"
      		read startPoint
      		testForHex
      		;;
      	esac
        ;;
    esac
}

function spoofMAC {
	ifconfig en1 ether $finalMAC		#	Set the MAC address to the value of 'finalMAC'
	sleep 1								#	Sleeping for slower systems
	ifconfig en1 down					#	Wi-Fi disabled
	sleep 1
	ifconfig en1 up						#	Enable Wi-Fi
	sleep $sleepTime					#	Sleep for the requested duration
}

function setHex {
	while [ $endHex -lt 256 ]; do		#	While count value is less than 256, we have
										#	a valid hex value (as an integer)
		hex=$(printf "%02x" $endHex)	#	Converts the 6th MAC octet to hex
		endHex=$((endHex + 1))			#	Increment the 6th MAC octet
		finalMAC=$MAC$hex				#	Concat the 6th octet to the first 5
		spoofMAC						#	Run the spoofing function
	done

#	If count value is 255, we have exhausted all valid octet values and need to restart.

	endHex=0							#	Reset the 6th MAC octet
	isFirstPass=0						#	Make sure we don't do any init stuff again
	if [ $includeNW == 1 ]; then
		spoofNintendo
	fi
	scriptStart							#	Run the script again

}

function includeNintendo {

	printf "Would you like to include the Nintendo World MACs in the cycle? Y or N\n"
	read nintendoMACS					#	Find out if user wants to include Nintendo
										#	World MACs in the cycle
	case $nintendoMACS in
		y*)
			printf "Including Nintendo World MACs.\n\n"
			includeNW=1
			;;
		Y*)
			printf "Including Nintendo World MACs.\n\n"
			includeNW=1
			;;
		n*)
			printf "Omitting Nintendo World MACs.\n\n"
			includeNW=0
			;;
		N*)
			printf "Omitting Nintendo World MACs.\n\n"
			includeNW=0
			;;
		*)
			printf "Please type either Y or N.\n\n"
			includeNintendo
			;;
	esac

}

function spoofNintendo {

cp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist /Library/Preferences/SystemConfiguration/xzone.preferences.plist.bak

defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences InternetSharing -dict-add SSID -data $ssid[01]

while [ $count -lt 6 ]; do

	case $count in
		0)
			finalMAC="00:25:9C:52:1C:6A"
			spoofMAC
			count=$((count + 1))
			;;
		1)
			finalMAC="00:0D:67:15:2D:82"
			spoofMAC
			count=$((count + 1))
			;;
		2)
			finalMAC="00:0D:67:15:D7:21"
			spoofMAC
			count=$((count + 1))
			;;
		3)
			finalMAC="00:0D:67:15:D5:44"
			spoofMAC
			count=$((count + 1))
			;;
		4)
			finalMAC="00:0D:67:15:D2:59"
			spoofMAC
			count=$((count + 1))
			;;
		5)
			finalMAC="00:0D:67:15:D6:FD"
			spoofMAC
			count=$((count + 1))
			;;
		*)
			echo "We seem to have encountered an error. Script will now terminate."
			return 1
			scriptAbort
			;;
	esac
done

rm /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist
mv /Library/Preferences/SystemConfiguration/xzone.preferences.plist.bak /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist

count=0

}

function scriptStart {

	if [ $isFirstPass == 1 ]; then
		includeNintendo							#	Determine if we must include NW MACs

		setCycle								#	Determine cycle frequency

		setStartOctet							#	Determine starting octet for MAC

		setSSID									#	Determine which SSID to use
	fi
	
	setHex

}

function setCycle {

printf "Please enter the time (in minutes) you wish the script\nto cycle through addresses:  "

read inputTime							#	Get the cycle time from the user

testForInteger							#	Make sure the user enters a valid number

if [ $inputTime -gt 1 ]; then			#	Ensure cycle value is > 2
	sleepTime=$((inputTime * 60))
	echo "Script will cycle addresses every" $inputTime "minutes ("$sleepTime "seconds)."
else
	sleepTime=120
	printf "Cycle value too low. Using default cycle of 2 minutes.\n\n"
fi

}

function setStartOctet {

printf "\nIf you would like to start at a specific MAC, enter the final\n2-digit hex value (octet) here. (This is useful if you have terminated\nthe script and wish to pick up where you left off) Otherwise, just hit return.\n"

read startPoint							#	Get starting point from user

testForHex								#	Make sure user entered a valid 2 digit octet

}

function setSSID {

cp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist.bak

printf "\nWhich SSID would you like to use?\n1. attwifi		2. NZ@McD1		3. (More ...)\n"

read getSSID

case $getSSID in
	1)
		gotssid=${ssid[01]}					#	attwifi SSID
		;;
	2)
		gotssid=${ssid[03]}					#	NZ@McD1 SSID
		;;
	3)
		#	Allow selecting from all SSIDs
		printf "\n\nThe following is a list of all possible SSIDs that can\nbe used as StreetPass Relays:\n\n"
		printf "1. attwifi		2. McDonalds Free WiFi	3. NZ@McD1	\n\n4. NZ@McD2		5. wifine		6. FREESPOT	\n\n7. noasp1		8. noasp2		9. Boingo Hotspot	\n\n10. boingo hotspot	11. ATL-Wi-Fi		12. Toronto Pearson Wi-Fi	\n\n13. AWG-WiFi		14. CLTNET		15. IND_PUBLIC_WiFi	\n\n16. LAX-WiFi		17. MIA-WiFi		18. RDU_WiFi	\n\n19. San.Diego.Airport.Free.WIFI			20. flysacramento	\n\n21. hotspot_Bell	22. BELLWIFI@MCDONALDS	23. Boulevard Saint-Laurent WIFI	\n\n"
		read -p "Press any key to continue... " -n1 -s
		printf "\n\n24. NintendoSpotPass1	25. NintendoSpotPass2	26. Nintendo_Zone1	\n\n27. Guglielmo		28. Guglielmo_Euronics	29. KPN	\n\n30. METEOR		31. MCDONALDS		32. CASINO_by_METEOR	\n\n33. WiFi Zone - The Cloud			34. mycloud	\n\n35. WLAN Zone - The Cloud			36. mycloud City WiFi	\n\n37. _The Cloud		38. free-hotspot.com	39. hotspot-gratuit.com	\n\n40. Autogrill_Free_WiFi	41. Autogrill Free WiFi	42. Quick WiFi	\n\n43. Quick Wi-Fi		44. Quick_WiFi		45. O2 Wifi	\n\n46. GOWEX FREE WiFi	\n\nPlease type the number of the SSID you wish to use:	"
		read getSSID
		while [ $getSSID -gt 46 ]; do
			echo "You have made an invalid selection. Please try again."
			read getSSID
		done
		gotssid=${ssid[$getSSID]}
		;;
	*)
		printf "Please type either 1, 2, or 3\n"
		setSSID
		;;
esac

defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences InternetSharing -dict-add SSID -data $gotssid

ssidName=$(echo $gotssid | xxd -r -p)

}

function scriptEnd {

sudo rm /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist
sudo cp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist.bak /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist

sudo ifconfig en1 ether ${originalMAC}
sleep 1
sudo ifconfig en1 down
sleep 1
sudo ifconfig en1 up

printf "\n\nThanks for using XZone!"
return 0

}

function scriptAbort {

printf "\n\nAborting script. Please wait while we clean up!"
scriptEnd
exit $?

}

#########################################################################################

clear									#	Clears the terminal window

#	We need to check if we are running as root to execute some of the commands.
if [ $UID != 0 ]; then

	echo "We neet root privileges for this!"
    sudo "$0" "$@"
    exit $?
    
fi

echo "Running as root. Proceeding."

trap scriptAbort SIGINT SIGTERM

scriptStart								#	Start running the script proper

scriptEnd								#	Perform a cleanup before quit
