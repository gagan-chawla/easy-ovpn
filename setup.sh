#!/bin/bash

cat .mark
DIR=$PWD

printf "Path to .ovpn file\n> "
read path

until [[ -f $path && $path == *.ovpn ]]; do
  printf "Incorrect file path. Try again\n> "
  read path
done

filename="${path##*/}"
cp $path .
printf "$filename copied to $DIR successfully.\n\n"

printf "Auth Username: "
read username
stty -echo
printf "Auth Password: "
read password
stty echo
printf "\nPassphrase: "
read passphrase
printf "Secret Authenticator Key: "
read secretkey

> creds/userpass.txt
> creds/passphrase.txt
> creds/secretkey
printf "$username\n$password" | openssl enc -base64 >> creds/userpass.txt
printf "$passphrase" >> creds/passphrase.txt
printf "$secretkey" | openssl enc -base64 >> creds/secretkey

printf "\nSETUP COMPLETE.\n"
printf "To get started, add 'source $DIR/main.sh' in your shell configuration file. Eg, for Bash, add it to .bashrc\n"
printf "To connect to vpn, simply type 'easyovpn'\n"
printf "Thanks!\n"
