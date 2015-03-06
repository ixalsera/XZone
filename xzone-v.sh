#!/bin/bash
#############################################################
#															#
#	XZone Bash Script 0.2 - Verbose - Scytheri0n			#
#															#
#	A simple bash script to create a HomePass network		#
#	on OS X.												#
#															#
#############################################################

#	We need to check if we are running as root to
#	execute some of the commands.

clear						#	Clears the terminal window

if [ $UID != 0 ]; then

	echo "We neet root privileges for this!"
    sudo "$0" "$@"
    exit $?
    
fi

echo "Running as root. Proceeding."

MAC="4e:53:50:4f:4f:"		#	The initial 5 hex values of the MAC
endHex=00					#	The 6th hex value for the MAC
count=0						#	Loop count
finalMAC=""					#	The final MAC address that will be spoofed
sleepTime=120				#	How long the script must pause for

printf "Please enter the time (in minutes) you wish the script\nto cycle through addresses:  "

read inputTime				#	Get the cycle time from the user

function testForInteger {
	re='^[0-9]+$'
	if ! [[ $inputTime =~ $re ]] ; then			#	Makes sure $inputTime is an integer
 	  echo "You did not enter a valid number. Please try again."
 	  printf "Please enter the time (in minutes) you wish the script\nto cycle through addresses:  "
 	  read inputTime
 	  testForInteger
	fi
}

testForInteger				#	Make sure the user enters a valid number.

if [ $inputTime -gt 2 ]; then
	sleepTime=$((inputTime * 60))
	echo "Script is cycling addresses every" $inputTime "minutes ("$sleepTime "seconds)."
else
	sleepTime=120
	echo "Cycle value too low. Using default cycle of 2 minutes."
fi


function spoofMAC {
	echo "Spoofing MAC!"
	ifconfig en1 ether $finalMAC		#	Set the MAC address to the value of 'finalMAC'
	echo "MAC spoofed to "$finalMAC
	echo "Resetting Wi-Fi ..."
	sleep 1								#	Sleeping for slower systems
	ifconfig en1 down					#	Wi-Fi disabled
	sleep 1
	ifconfig en1 up						#	Enable Wi-Fi
	echo "Wi-Fi reset!"
	sleep $sleepTime					#	Sleep for the requested duration
}

function setHex {
	if [ $count -lt 255 ]; then			#	If the count value is less than 255, we have
										#	a valid hex value (as an integer)
		hex=$(printf "%02x" $endHex)	#	Converts the 6th MAC value to hex
		endHex=$((endHex + 1))			#	Increment the 6th MAC value
		finalMAC=$MAC$hex				#	Concat the 6th value to the first 5
		spoofMAC						#	Run the spoofing function
		count=$((count + 1))			#	Increment the loop count
		setHex							#	Run the loop again

	else								#	If count value is 255, we have exhausted all
										#	valid hex values and need to restart.
		echo "Starting again!"
		count=0							#	Reset the loop count
		endHex=0						#	Reset the 6th MAC value
		setHex							#	Run the loop again

	fi
}

setHex									#	Start running the script proper

