import argparse
import time

from contractAPI import utils as utils
from contractAPI import getContract as getContract

rounds = 20
min_num_server = 1
min_local_upload_rate = 80 # percent
min_aggr_upload_rate = 80 #percent
interval = 30
short_interval = 2

def host (config, contrJson, contrTxJson=None, miner=None):
    contract = getContract.get_contract(config, contrJson, contrTxJson=None, miner=None)

    w3 = utils.getProvider(config, miner)
    w3.geth.miner.start(2)
    
    for r in range(rounds):
        print("Round = " + str(r))
        if (contract.functions.get_cur_round().call() > r):
            continue

        # stage 1
        while (contract.functions.get_num_listener().call() < min_num_server):
            time.sleep(short_interval)
            if (contract.functions.get_cur_round().call() > r):
                break
        if (not contract.functions.get_stage_locks().call()[0]):
            contract.functions.start_next_round(r).transact({'from': w3.eth.accounts[0]})
        
        # stage 2
        time.sleep(interval) # minimal training time
        while ((contract.functions.get_num_listener().call() < min_num_server) or (len(contract.functions.get_ipfs_urls().call()) * 100 < contract.functions.get_num_listener().call() * min_local_upload_rate)):
            time.sleep(short_interval)
            if (contract.functions.get_cur_round().call() > r):
                break
        if (not contract.functions.get_stage_locks().call()[1]):
            contract.functions.stop_training(r).transact({'from': w3.eth.accounts[0]})
        
        # set global model
        time.sleep(interval) # minimal aggregation time
        while ((contract.functions.get_num_listener().call() < min_num_server) or (len(contract.functions.get_aggregated_models().call()) * 100 < contract.functions.get_num_listener().call() * min_aggr_upload_rate)):
            time.sleep(short_interval)
            if (contract.functions.get_cur_round().call() > r):
                break
        if (not contract.functions.get_stage_locks().call()[2]):
            contract.functions.set_global_model(r).transact({'from': w3.eth.accounts[0]})

        # sync
        while (contract.functions.get_cur_round().call() <= r):
            time.sleep(short_interval)

def argparse_for_main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=str, required=False)
    parser.add_argument('--miner', type=str, required=False)
    parser.add_argument('--contrjson', type=str, required=True)
    parser.add_argument('--contrtxjson', type=str, required=False)
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = argparse_for_main()
    time.sleep(3) # wait for listener-up
    host(args.config, args.contrjson, args.contrtxjson, args.miner)