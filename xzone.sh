#!/bin/bash
#
#
#		#############################################################
#		#															#
#		#	XZone Bash Script 0.3 - Scytheri0n						#
#		#															#
#		#	A simple bash script to create a HomePass network		#
#		#	on OS X.												#
#		#															#
#		#############################################################
#
#	Changelog:
#
#	0.3		-	Corrected script to not mistakenly warn that 2 minutes is too low
#				a cycle rate as well as corrected skipping of "ff" MAC. Included Nintendo #				World MACs. Allowed starting from custom MAC increment. Cleaned up script.
#
#	0.2		-	Allow user to enter a custom cycle rate
#
#	0.1		-	Initial release.
#
########################################################################################

#	Variables

MAC="4e:53:50:4f:4f:"					#	The initial 5 hex values of the MAC
endHex=00								#	The 6th hex value for the MAC
count=0									#	Loop count
finalMAC=""								#	The final MAC address that will be spoofed
sleepTime=120							#	How long the script must pause for
includeNW=0								#	Nintendo World MACs included or not
isFirstPass=1							#	Is the script running again?

########################################################################################

#	Function Declarations

function testForInteger {				#	Makes sure $inputTime is an integer
	re='^[0-9]+$'
	if ! [[ $inputTime =~ $re ]] ; then
 	  printf "You did not enter a valid number. Please try again.\n"
 	  read inputTime
 	  testForInteger
	fi
}

function testForHex {					#	Makes sure $startPoint is a hex value
	case $startPoint in
      ( *[!0-9A-Fa-f]* ) 
      	printf "Not a valid hex value. Please try again.\n"
      	read startPoint
      	testForHex
      	;;
      ( * )                
        case ${#startPoint} in
        2)
        	endHex=$startPoint
        	endHex=$((0x${endHex}))
        	;;
        *)
        	printf "Please make sure the value is two digits exactly.\n"
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
		hex=$(printf "%02x" $endHex)	#	Converts the 6th MAC value to hex
		endHex=$((endHex + 1))			#	Increment the 6th MAC value
		finalMAC=$MAC$hex				#	Concat the 6th value to the first 5
		spoofMAC						#	Run the spoofing function
	done

#	If count value is 255, we have exhausted all valid hex values and need to restart.

	endHex=0							#	Reset the 6th MAC value
	isFirstPass=0						#	Make sure we don't do any init stuff again
	if [ $includeNW == 1 ]; then
		spoofNintendo
	fi
	scriptStart							#	Run the script again

}

function includeNintendo {

	printf "Would you like to include the Nintendo World MACs in the cycle? Y or N \n"

	read nintendoMACS					#	Find out if user wants to include Nintendo
										#	World MACs in the cycle
	case $nintendoMACS in
		y*)
			echo "Including Nintendo World MACs."
			includeNW=1
			;;
		Y*)
			echo "Including Nintendo World MACs."
			includeNW=1
			;;
		n*)
			echo "Omitting Nintendo World MACs."
			includeNW=0
			;;
		N*)
			echo "Omitting Nintendo World MACs."
			includeNW=0
			;;
		*)
			echo "Please type either Y or N."
			includeNintendo
			;;
	esac

}

function spoofNintendo {

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
			exit 1
			;;
	esac
done

count=0

}

function scriptStart {

	if [ $isFirstPass == 1 ]; then
		printf "\nScript Starting!\n\n"
	fi
	
	setHex

}

#########################################################################################


clear									#	Clears the terminal window

#	We need to check if we are running as root to execute some of the commands.

if [ $UID != 0 ]; then

	echo "We neet root privileges for this!"
    sudo "$0" "$@"
    exit $?
    
fi

includeNintendo

printf "Please enter the time (in minutes) you wish the script\nto cycle through addresses:  "

read inputTime							#	Get the cycle time from the user

testForInteger							#	Make sure the user enters a valid number

if [ $inputTime -gt 1 ]; then			#	Ensure cycle value is > 2
	sleepTime=$((inputTime * 60))
	echo "Script will cycle addresses every" $inputTime "minutes ("$sleepTime "seconds)."
else
	sleepTime=120
	echo "Cycle value too low. Using default cycle of 2 minutes."
fi

printf "If you would like to start at a specific MAC, enter the final\n2-digit hex value here. (This is useful if you have terminated the script\nand wish to pick up where you left off) Otherwise, just hit return.\n"

read startPoint							#	Get starting point from user

testForHex								#	Make sure user entered a valid 2 digit hex

scriptStart								#	Start running the script proper

