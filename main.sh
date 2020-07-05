#!/bin/bash

EASY_OVPN_DIR=$(dirname "${BASH_SOURCE:-$0}")
EASY_OVPN_FILE=$(find $EASY_OVPN_DIR -maxdepth 1 -name '*.ovpn' | head -1)

easyovpn () {
	local auth_user_pass=$(openssl enc -base64 -d < $EASY_OVPN_DIR/creds/userpass)
	local askpass=$(openssl enc -base64 -d < $EASY_OVPN_DIR/creds/passphrase)
	local auth_code=$(python $EASY_OVPN_DIR/oath/2fa.py "$EASY_OVPN_DIR")
	sudo su -c "openvpn --config \"$EASY_OVPN_FILE\" --auth-user-pass <(echo -ne \"$auth_user_pass$auth_code\") --askpass <(echo -ne \"$askpass\")"
}
