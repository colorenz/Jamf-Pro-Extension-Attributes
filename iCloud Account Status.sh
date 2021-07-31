#!/bin/bash

# Purpose: to grab iCloud status
# Values will be either "Enabled" or "Disabled"

#Determine logged in user
loggedInUser=$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')

if [[ -e "/Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist" ]]; then
	#Path to PlistBuddy
	plistBud="/usr/libexec/PlistBuddy"

	iCloudStatus=$("$plistBud" -c "print :Accounts:0:LoggedIn" /Users/$loggedInUser/Library/Preferences/MobileMeAccounts.plist 2> /dev/null )

	if [[ "$iCloudStatus" = "true" ]]; then
		iCloudStatus="Enabled"
	fi
	if [[ "$iCloudStatus" = "false" ]] || [[ -z "$iCloudStatus" ]]; then
		iCloudStatus="Disabled"
	fi
else
	iCloudStatus="Disabled"
fi

/bin/echo "<result>$iCloudStatus</result>"
