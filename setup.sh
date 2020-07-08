#!/bin/bash

RED='\033[01;31m'
GREEN='\033[01;32m'
BLUE='\033[01;34m'
CYAN='\033[01;36m'

cat .mark

DIR=$PWD
CHE=()
CHD="Remove and re-copy from original location"
CHQ="Quit"
KEEP="Keep "

while IFS= read -r -d '' ex; do
	CHE+=( "$KEEP$ex" )
done < <(find $DIR -maxdepth 1 -type f -name '*.ovpn' -print0)
if (( ${#CHE[@]} )); then
	printf "Only one .ovpn file should exist in this directory!\n"
	select choice in "${CHE[@]}" "$CHD" $CHQ; do
		if [ $REPLY -le ${#CHE[@]} ]; then
			keepfile=${CHE[$REPLY-1]#"$KEEP"}
			for ch in "${CHE[@]#$KEEP}"; do
				if [ "$ch" != "$keepfile" ]; then
					rm -f "$ch"
				fi
			done
			break
		elif [ "$choice" = "$CHD" ]; then
			printf "%s\0" "${CHE[@]#$KEEP}" | xargs -0I{} rm -f {} || exit 1
			break
		elif [ "$choice" = "$CHQ" ]; then
			exit 0
		else
			printf "Invalid choice. Try again.\n"
		fi
	done
fi

if [ -z "$keepfile" ]; then
	printf "Path to .ovpn file\n> "
	read path
	until [[ -f "$path" && "$path" == *.ovpn ]]; do
		printf "Incorrect file path. Try again\n> "
		read path
	done
	filename="${path##*/}"
	cp "$path" . || { printf "Copy failed!"; exit 1; }
	printf "%s\n" "$filename copied to $DIR successfully."
fi

printf "\nAuth Username: "
read username
stty -echo
printf "Auth Password: "
read password
stty echo
printf "\nPassphrase: "
read passphrase

printf "Secret Authenticator Key: "
read secretkey

> creds/userpass
> creds/passphrase
> creds/secretkey
echo -ne "$username\n$password" | openssl enc -base64 >> creds/userpass
echo -ne "$passphrase" | openssl enc -base64 >> creds/passphrase
echo -ne "$secretkey" | openssl enc -base64 >> creds/secretkey

source $DIR/main.sh

printf "\nSETUP COMPLETE.\n"
printf "To get started, add 'source $DIR/main.sh' in your shell configuration file. Eg, for Bash, add it to .bashrc\n"
printf "To connect to vpn, simply type 'easyovpn'\n"
printf "Thanks!\n"
exit 0
