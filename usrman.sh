#!/bin/bash

# usrman is a shell tool to make, remove, edit users.

# Error function
err() {
	echo -e "\e[31m[$(date +'%Y-%m-%dT%H:%M:%S%z')] ERROR: $*\e[0m" >&2
	exit 1
}

# Warn function
warn() {
	echo -e "\e[35m[$(date +'%Y-%m-%dT%H:%M:%S%z')] WARN: $*\e[0m" >&2
}

# err "This is an error"
# warn "This is a warning"


# Main program loop
mainmenu() {
	clear
	echo "Please enter your password as permissions are needed to do some actions..."
	# This is done so sudo doesnt ask for the password on the first action the user does :D
	sudo clear
	warn "Any damage caused by/with this tool is your responsibility."
	echo "----------------------------"
	echo "           USRMAN           "
	echo "----------------------------"
	echo
	echo
	echo "Press 1 to create a new user."
	echo "Press 2 to remove a user."
	echo "Press 3 to add an user to sudoers."
	echo "Press 4 to print the sudoers file."
	echo "Press 5 to remove a user from sudoers file."
	echo "Press 6 to change password of a user."
	echo "Press 7 to exit."
	read  -n 1 -p "What do you want to do? " mainmenuinput
	if [ "$mainmenuinput" = "1" ]; then
		clear
		newuser
	elif [ "$mainmenuinput" = "2" ]; then
		clear
		removeuser
	elif [ "$mainmenuinput" = "3" ]; then
		clear
		addsudoer
	elif [ "$mainmenuinput" = "4" ]; then
		clear
		print_sudoers
	elif [ "$mainmenuinput" = "5" ]; then
		clear
		removesudoer
	elif [ "$mainmenuinput" = "6" ]; then
		clear
		change_passwd
	elif [ "$mainmenuinput" = "7" ]; then
		clear
		exit_prog
	else
		clear
		mainmenu
	fi
}

newuser() {
	warn "Any damage caused by/with this tool is your responsibility."
	echo "------------------------------"
	echo "       Create new user        "
	echo "------------------------------"
	echo
	read -p "What is the username for the new user? (Type c! to cancel) " username
	if [ "$username" = "c!" ]; then
		clear
		mainmenu
	fi
	sudo adduser $username
	if [ $? -eq 0 ]; then
		echo
	else
		err "Creating the user failed."
	fi
	warn "Creating the user is done!"
	echo "Press 1 to go back to the menu."
	echo "Press 2 to remove a user."
	read  -n 1 -p "What do you want to do? " newuserdone
	if [ "$newuserdone" = "1" ]; then
		clear
		mainmenu
	elif [ "$newuserdone" = "2" ]; then
		clear
		removeuser
	else
		clear
		mainmenu
	fi
}

removeuser() {
	warn "Any damage caused by/with this tool is your responsibility."
	echo "------------------------------"
	echo "         Remove a user        "
	echo "------------------------------"
	echo
	read -p "What is the username for the user that is going to be deleted? (Type c! to cancel) " username_del
	if [ "$username_del" = "c!" ]; then
		clear
		mainmenu
	fi
	sudo deluser $username_del
	if [ $? -eq 0 ]; then
		echo
	else
		err "Creating the user failed."
	fi
	warn "Removing the user is done!"
	echo "Press 1 to go back to the menu."
	echo "Press 2 to create a new user."
	read  -n 1 -p "What do you want to do?:" remuserdone
	if [ "$remuserdone" = "1" ]; then
		clear
		mainmenu
	elif [ "$remuserdone" = "2" ]; then
		clear
		newuser
	else
		clear
		mainmenu
	fi
}

exit_prog() {
	warn "Thanks for using the usrman tool!"
	warn "Have a good day!"
	read -n 1 -p "Are you sure you want to exit? (y/n)" exit_sure
	if [ "$exit_sure" = "y" ]; then
		clear
		exit
	elif [ "$exit_sure" = "n" ]; then
		clear
		mainmenu
	else
		clear
		exit_prog
	fi
}

addsudoer() {
	# etc/sudoers.tmp
	warn "Any damage caused by/with this tool is your responsibility."
	echo "------------------------------"
	echo "     Add a user to sudoers    "
	echo "------------------------------"
	echo
	read -p "What is the username for the user that is going to be added to the sudoers file? (Type c! to cancel) " username_sudo
	sudo usermod -aG sudo $username_sudo
	if [ $? -eq 0 ]; then
		echo
	else
		err "Adding the user to sudoers failed."
	fi
	warn "Adding the user to sudoers is done! Returning to main menu in 5 seconds..."
	sleep 5
	mainmenu
}

print_sudoers() {
	sudo cat /etc/sudoers
	echo
	echo
	warn "Printing the sudoers is done! Returning to main menu in 20 seconds..."
	sleep 20
	mainmenu
}

removesudoer() {
	warn "Any damage caused by/with this tool is your responsibility."
	echo "------------------------------"
	echo "  Remove a user from sudoers  "
	echo "------------------------------"
	echo
	read -p "What is the username for the user that is going to be removed from the sudoers file? (Type c! to cancel) " username_sudo_rem
	sudo deluser $username_sudo_rem sudo
	if [ $? -eq 0 ]; then
		echo
	else
		err "Removing the user from sudoers failed."
	fi
	warn "Removing the user from sudoers is done! Returning to main menu in 5 seconds..."
	sleep 5
	mainmenu
}

change_passwd() {
	warn "Any damage caused by/with this tool is your responsibility."
	echo "------------------------------"
	echo "         Change password      "
	echo "------------------------------"
	echo
	read -p "Which accounts password do you want to change? (Type c! to cancel) " username_chng_passwd
	sudo passwd $username_chng_passwd
	if [ $? -eq 0 ]; then
		echo
	else
		err "Changing the user $username_chng_passwd s password failed."
	fi
	warn "Changing the password is done! Returning to main menu in 5 seconds..."
	sleep 5
	mainmenu
}

mainmenu
