import argparse
try: 
    import getContract
    import util
except:
    from . import getContract
    from . import util
import time

sleep = 30

def host(config, contrJson, contrTxJson=None, miner=None):
    contract = getContract.get_contract(config, contrJson, contrTxJson=None, miner=None)

    w3 = util.getProvider(config, miner)
    w3.geth.miner.start(2)
    
    # contract.functions.start_next_round(callEvent=True).transact({'from': w3.eth.accounts[0]})
    # contract.functions.stop_training(callEvent=True).transact({'from': w3.eth.accounts[0]})
    # contract.functions.set_global_model().transact({'from': w3.eth.accounts[0]})
    while(True):
        time.sleep(2)
        print("========")
        print("GLOBAL model:\t\t\t || ",contract.functions.get_global_model().call())
        print("servers' model uploaded (ipfs):\t || ",contract.functions.get_ipfs_urls().call())
        print("AGGREGATED model by aggregator:\t || ",contract.functions.get_aggregated_models().call())
        print("========")
  

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
    host(args.config, args.contrjson, args.contrtxjson, args.miner)