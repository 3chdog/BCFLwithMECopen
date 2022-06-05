from web3 import Web3
import argparse

from . import utils

config = "config/eth_config.json"
miner = "miner1"
contrjson = "contracts/FL.json"
contrtxjson = "contracts/FL_deployed_tx_receipt.json"

class FL_Contract():
    def __init__(self):
        from . import getContract
        contract = getContract.get_contract(config, contrjson, contrtxjson, miner)
        self.w3 = utils.getProvider(config)
        self.contract = contract
        self.minerAddr = self.w3.eth.accounts[0]
        self.w3.geth.miner.start(2)

    def get_ipfs_urls(self):
        return self.contract.functions.get_ipfs_urls().call()

    def append_ipfs_url(self, newUrl:str, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        self.contract.functions.append_ipfs_url(newUrl).transact({'from': minerAddr})
        return 0

    def append_aggregated_models(self, modelUrl:str, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        self.contract.functions.append_aggregated_models(modelUrl).transact({'from': minerAddr})
        return 0

    def get_global_model(self):
        return self.contract.functions.get_global_model().call()


# only for getting contract in self running (for testing)
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
    import getContract
    contract = getContract.get_contract(args.config, args.miner, args.contrjson, args.contrtxjson)
    w3 = utils.getProvider(args.config)
    mycontract = FL_Contract(contract, w3.eth.accounts[0])
