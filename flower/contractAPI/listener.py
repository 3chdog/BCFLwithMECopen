from web3 import Web3
import json
import asyncio
import argparse
import subprocess
try:
    import util
    import getContract
except:
    from . import util
    from . import getContract
import time

#TODO: handle events

sleep = 10
parser = argparse.ArgumentParser()
parser.add_argument('--config', type=str, required=False)
parser.add_argument('--miner', type=str, required=False)
parser.add_argument('--contrjson', type=str, required=True)
parser.add_argument('--contrtxjson', type=str, required=False)
args = parser.parse_args()
w3 = util.getProvider(args.config, args.miner)
w3.geth.miner.start(2)
contract = getContract.get_contract(args.config, args.contrjson, contrTxJson=None, miner=None)

def preparing():
    # join if not in the group
    if (contract.functions.check_in_group(w3.eth.accounts[0]).call() == False):
        print("join!")
        tx_hash = contract.functions.join_a_group().transact({'from': w3.eth.accounts[0]})
        w3.eth.wait_for_transaction_receipt(tx_hash)
        print("joined!")
    # if contract.functions.get_role(w3.eth.accounts[0]).call() == "host":
    #     cmd = ["./host.sh"]
    #     subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    #     print("host_up")


def handle_go_training():
    cmd = ["./go_training.sh"]
    cmd2 = ["./client.sh"]
    subprocess.Popen(cmd, text=True)
    time.sleep(10)
    subprocess.Popen(cmd2, text=True)
    print("start_training")
    return

def handle_go_aggregate():
    cmd = ["./go_aggregating.sh"]
    subprocess.Popen(cmd, text=True)
    print("start_aggregating")
    return

async def listen_events(event_filter, sleep):
    while True:
        for event in event_filter.get_new_entries():
            # which event
            is_training = event.topics[0].hex() == Web3.keccak(text="go_training()").hex()
            is_aggregate = event.topics[0].hex() == Web3.keccak(text="go_aggregate()").hex()
            if is_training:
                handle_go_training()
            if is_aggregate:
                if (contract.functions.get_role(w3.eth.accounts[0]).call() == "host") or (contract.functions.get_role(w3.eth.accounts[0]).call() == "aggregator"):
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
    print("Have joined.\nPLEASE RUN \"host.sh\" ...")
    event_filter = get_filter(["go_training()", "go_aggregate()"])

    loop = asyncio.get_event_loop()
    loop.run_until_complete(listen_events(event_filter, sleep))
    loop.close()
