from web3 import Web3
import json
import asyncio
import argparse
import subprocess
import time

from contractAPI import utils as utils
from contractAPI import getContract as getContract

sleep = 10
parser = argparse.ArgumentParser()
parser.add_argument('--config', type=str, required=False)
parser.add_argument('--miner', type=str, required=False)
parser.add_argument('--contrjson', type=str, required=True)
parser.add_argument('--contrtxjson', type=str, required=False)
parser.add_argument('--grpcport', type=str, required=True)
args = parser.parse_args()
w3 = utils.getProvider(args.config, args.miner)
w3.geth.miner.start(2)
contract = getContract.get_contract(args.config, args.contrjson, contrTxJson=None, miner=None)

def preparing():
    cmd = ["./host.sh"]
    subprocess.Popen(cmd, text=True)
    print("host_up")


def handle_go_training():
    cmd = ["./go_training.sh", str(args.grpcport)]
    cmd2 = ["./client.sh", str(args.grpcport)]
    subprocess.Popen(cmd, text=True)
    time.sleep(15)
    subprocess.Popen(cmd2, text=True)
    print("start_training")
    return

def handle_go_aggregate():
    cmd = ["./go_aggregating.sh"]
    subprocess.Popen(cmd, text=True)
    print("start_aggregating")
    return

async def listen_events(event_filter, sleep):
    # interact with contract
    contract.functions.add_listener().transact({'from': w3.eth.accounts[0]})
    while True:
        for event in event_filter.get_new_entries():
            # which event
            is_training = event.topics[0].hex() == Web3.keccak(text="go_training()").hex()
            is_aggregate = event.topics[0].hex() == Web3.keccak(text="go_aggregate()").hex()
            if is_training:
                handle_go_training()
            if is_aggregate:
                handle_go_aggregate()
        await asyncio.sleep(sleep)

def get_filter(events):
    with open(args.contrtxjson) as f:
        TxJson = json.load(f)
    myContract_address = TxJson["contractAddress"]

    topics = [[]]
    for i in range(len(events)):
        topics[0].append(Web3.keccak(text=events[i]).hex())

    event_filter = w3.eth.filter({
        "address": myContract_address,
        "topics": topics
    })

    return event_filter
    

if __name__ == "__main__":
    preparing()
    print("Have joined.\nPLEASE CHECK # of listeners\nThere should be 2 terminal running ./listner_up.sh ...")
    event_filter = get_filter(["go_training()", "go_aggregate()"])

    loop = asyncio.get_event_loop()
    loop.run_until_complete(listen_events(event_filter, sleep))
    loop.close()
