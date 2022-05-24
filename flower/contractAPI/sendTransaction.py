from web3 import Web3
import argparse
import json
import util


def send_transaction(config, tx, miner=None):
    w3 = util.getProvider(config, miner)
    w3.eth.default_account = w3.eth.accounts[0]
    print("Account Balance:", w3.eth.get_balance(w3.eth.default_account))
    tx_sent = w3.eth.send_transaction(tx)
    print("Transaction Hash:", tx_sent.hex())
    return tx_sent.hex()



def argparse_for_main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=str, required=False)
    parser.add_argument('--miner', type=str, required=False)
    parser.add_argument('--tx', type=str, required=False)
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = argparse_for_main()
    w3 = util.getProvider(args.config, args.miner)

    if args.tx==None:
        # define tx
        amount = 0.00004
        from_address = "0xeb42a910418f706f0847f3715c66b44764626e66" # miner1 first account
        to_address = "0xbca61243a8d4f3264835c02660e4c5c8aa9bbb81" # miner2
        from_address_checksum = Web3.toChecksumAddress(from_address)
        to_address_checksum = Web3.toChecksumAddress(to_address)
        nonce = w3.eth.getTransactionCount(from_address_checksum)
        print("from_address: {}\nNONCE: {}".format(from_address_checksum, nonce))
        amount=0.00004
        tx = {
        'from': from_address_checksum, # '0x...'
        'to': to_address_checksum, # '0x...'
        'value': w3.toWei(amount, 'ether'),
        'gas': 210000,
        'gasPrice': w3.eth.gas_price,
        'nonce': nonce,
        'chainId': 2539, # see mynet.json (build when you start the genesis)
        #'data': '0x123',
        #'logsBloom': "0xcccaaa00000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000040000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        }
    else:
        with open(args.tx, 'r') as f:
            tx = json.load(f)

    w3.geth.miner.start(2)
    send_transaction(args.config, tx)
    w3.geth.miner.stop()