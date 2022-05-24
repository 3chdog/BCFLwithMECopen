import argparse
try: 
    import getContract
    import util
except:
    from . import getContract
    from . import util
import time

sleep = 30

def host (config, contrJson, contrTxJson=None, miner=None):
    contract = getContract.get_contract(config, contrJson, contrTxJson=None, miner=None)

    w3 = util.getProvider(config, miner)
    w3.geth.miner.start(2)
    
    for rounds in range(2):
        print("\n\n----- Hyper Round #: {}\n".format(rounds))
        tx_contr = contract.functions.start_next_round(callEvent=True).transact({'from': w3.eth.accounts[0]})
        w3.eth.wait_for_transaction_receipt(tx_contr)
        print("Starting Next Round...")
        #time.sleep(sleep)

        # WAIT for all servers uploading models to ipfs
        # num of ipfs_urls == num_members (num of flower servers)
        while(True):
            if (len(contract.functions.get_ipfs_urls().call()) == contract.functions.num_members().call()):
                tx_all_server = contract.functions.stop_training(callEvent=True).transact({'from': w3.eth.accounts[0]})
                break
            time.sleep(2)
        w3.eth.wait_for_transaction_receipt(tx_all_server)
        print("All flower servers finished uploading. GO AGGREGATE...")

        # WAIT for all aggregators uploading aggregated models
        # num of aggregated_models == {num}
        while(True):
            if ((len(contract.functions.get_aggregated_models().call()) == 1)):
                tx_hash = contract.functions.set_global_model().transact({'from': w3.eth.accounts[0]})
                w3.eth.wait_for_transaction_receipt(tx_hash)
                break
            time.sleep(2)

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