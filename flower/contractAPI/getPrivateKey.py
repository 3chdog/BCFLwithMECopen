import argparse
from web3.auto import w3

def get_private_key(keystorePath, passwd):
    with open(keystorePath) as keyfile:
        encrypted_key = keyfile.read()
        private_key = w3.eth.account.decrypt(encrypted_key, passwd)
        # tip: do not save the key or password anywhere, especially into a shared source file
        return private_key.hex()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-k','--keystore', type=str, required=True)
    parser.add_argument('-p', '--passwd', type=str, required=True)
    args = parser.parse_args()
    print(get_private_key(args.keystore, args.passwd))