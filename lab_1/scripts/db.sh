#!/bin/bash

alphabet=abcdefghijklmnopqrstuvwxyz
now=`date +"%d_%m_%Y"`
db=../data/users.db

# Checks if the database exists

isDb() {
        if [[ ! -f "$db" ]]; then
                touch "$db"
        fi
}

isDb

# Writes user input to ../data/users.db

add() {
	read -p "Please type your username (Latin letters only): " username
	read -p "Please type your role (Latin letters only): " role
	echo "username: $username, role: $role"
	if [[ "$username" =~ [alphabet] ]] && [[ "$role" =~ [alphabet] ]]; then
		printf "\n$username, $role\n" >> $db
	else
		echo "Please use only latin letters for username and role"
	fi
}

# Creates a backup for the database

backup() {
	cp ../data/users.db ../data/$now-users.db
}

# Restores backup to the users.db
 
restore() {
	date_format="^([0-9]{2})_([0-9]{2})_([0-9]{4})*$"
	last_backup=$(find "../data" -type f -iname "*-users.db" |sort |head -n1)
	if [[ ! -z ${last_backup} ]]; then
		cat $last_backup > $db
		echo -e "\033[32mDatabase was successfully restored\033[0m"
	else
		echo -e "\033[31mNo backup file found\033[0m"
	fi
}

# Finds user info in the database

find() {
	read -p "Please type searching username (Latin letters only): " username
	found_user=$(grep -F $username $db);
	if [[ ! -z ${found_user} ]]; then
                echo -e "\033[32mFounded users: \033[0m"
		echo "$found_user"
        else
                echo -e "\033[31mUser not found\033[0m"
        fi
}

# Prints list of existing users

list() {
{	
n=1
    for ((i=2;i--;)) ;do
        read
        done
    while read line ;do
        echo "$n. $line"
	n=$((n+1))
    done
} < $db	
}

help() {
	echo -e "\033[33m----------Help----------\033[0m"
	echo -e "\033[32madd\033[0m - Allows you to add a new username and role to the database"
	echo -e "\033[32mbackup\033[0m - Allows you to backup the database"
	echo -e "\033[32mrestore\033[0m - Allows you to restore a database from a backup file"
	echo -e "\033[32mfind\033[0m - Allows you to find a specific user in database"
	echo -e "\033[32mlist\033[0m - Allows you to print a list of users from database"
	echo -e "\033[33m------------------------\033[0m"
}

"$@"
