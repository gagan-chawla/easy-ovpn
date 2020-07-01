#!/bin/bash

DIR=$(dirname $0)
FILE=$(find $DIR -maxdepth 1 -name '*.ovpn' | head -1)

easyovpn () {
	local auth_user_pass=$(openssl enc -base64 -d < $DIR/creds/userpass.txt)
	local askpass=$(< $DIR/creds/passphrase.txt)
	local auth_code=$(python $DIR/oath/2fa.py $DIR)
	# > ~/vpn/bwell_vpn/temp.txt
	# echo -e "$auth_user_pass$auth_code" >> /home/ubuntu/vpn/bwell_vpn/temp.txt
	sudo openvpn --config $FILE --auth-user-pass =(echo -ne "$auth_user_pass$auth_code") --askpass =(echo -ne "$askpass")
}
