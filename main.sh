#!/bin/bash

EASY_OVPN_DIR=$(dirname $0)
EASY_OVPN_FILE=$(find $EASY_OVPN_DIR -maxdepth 1 -name '*.ovpn' | head -1)
easyovpn () {
	local auth_user_pass=$(openssl enc -base64 -d < $EASY_OVPN_DIR/creds/userpass.txt)
	local askpass=$(< $EASY_OVPN_DIR/creds/passphrase.txt)
	local auth_code=$(python $EASY_OVPN_DIR/oath/2fa.py $EASY_OVPN_DIR)
	sudo openvpn --config $EASY_OVPN_FILE --auth-user-pass =(echo -ne "$auth_user_pass$auth_code") --askpass =(echo -ne "$askpass")
}
