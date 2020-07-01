import base64
import sys
import totp

if __name__ == "__main__":
	DIR = sys.argv[1]
	with open(DIR+"/creds/secretkey") as f:
		cipher = f.readline().split('\n')[0]
		key = base64.b64decode(cipher)        
		otp = totp.TOTP(key)
		print(otp.now())

