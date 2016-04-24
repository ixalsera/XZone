# Changelog

* 0.8
   * Fixed problems on ifconfig interfaces now the script should use the correct ones.

* 0.7
   1. Fixed bug with resuming where it would use the last used MAC address instead of using the next in sequence.
   2. Cleaned up a little redundancy.
   3. Added option of resuming from arrays (such as Nintendo Zones).

* 0.6
   1. Fixed a bug with setting the SSID for Nintendo World MACs.
   2. Added an option to change preferences on start up, rather than having to reset all preferences.
   3. Improved launch flag option handling.
   4. Shifted preference checking forward to avoid changes being lost or ignored.
   5. Added logging to file as default instead of verbose.
   6. Fixed piping of output for other options.
   7. Added a To-Do list. Whoop!
   8. Switched to backing up of IS prefs once only to avoid accidental overwrites.
   9. Switched to "lladdr" instead of "ether" for "ifconfig".
   10. Actual MAC now logged instead of tweaked variable.
   11. Made sure XZone support folder is only created if it doesn't exist.
   12. Display settings after running a change prefs call.
   13. Removed SSIDs no longer accepted by latest firmware.
   14. Allowed "0" as an option for cycle frequency (i.e. Cycling disabled).
   15. Squashed a little tick on the Lion's back.
   16. Added an upgrade check.
   17. Added custom MAC addresses added by GBATemp users.
   18. Added actual Nintendo Zone MACs. Whew!

* 0.5
   1. __Preferences!__ XZone will now save user choices into a .plist and recall them at next start.
   2. Fixed a little bug with the SSID array.
   3. Improved getting input from user on first run.

* 0.4
   1. Improved Nintendo World function to ensure that "attwifi" SSID is used.
   2. Added SSIDs to allow for selecting SSID to spoof at start.
   3. Backs up current IS config and MAC to allow user to revert on exit.

* 0.3
   1. Corrected script to not mistakenly warn that 2 minutes is too low a cycle rate
   2. Corrected skipping of "ff" MAC.
   3. Included Nintendo World MACs.
   4. Allowed starting from custom MAC increment.
   5. Cleaned up script.

* 0.2
   * Allow user to enter a custom cycle rate

* 0.1
   * Initial release.