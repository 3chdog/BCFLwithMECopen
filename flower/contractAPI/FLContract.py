from web3 import Web3
import argparse
try:
    import util
except:
    from . import util

config = "config/eth_config.json"
miner = "miner1"
contrjson = "contracts/FL.json"
contrtxjson = "contracts/FL_deployed_tx_receipt.json"

class FL_Contract():
    def __init__(self):
        from . import getContract
        contract = getContract.get_contract(config, contrjson, contrtxjson, miner)
        self.w3 = util.getProvider(config)
        self.contract = contract
        self.minerAddr = self.w3.eth.accounts[0]
        self.w3.geth.miner.start(2)

    def join_a_group(self, AddressJoining:str, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        tx = contract.functions.join_a_group(AddressJoining).transact({'from': minerAddr})
        return tx.hex()

    def change_role(self, AddressToChange:str, newRole:str, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        tx = contract.functions.change_role(AddressToChange, newRole).transact({'from': minerAddr})
        return tx.hex()

    def get_ipfs_urls(self):
        return self.contract.functions.get_ipfs_urls().call()

    def append_ipfs_url(self, newUrl:str, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        self.contract.functions.append_ipfs_url(newUrl).transact({'from': minerAddr})
        return 0
        
    def reset_ipfs_urls(self, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        tx = contract.functions.reset_ipfs_urls().transact({'from': minerAddr})
        return tx.hex()

    def get_aggregated_models(self):
        return self.contract.functions.get_aaggregated_models().call()

    def append_aggregated_models(self, modelUrl:str, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        self.contract.functions.append_aggregated_models(modelUrl).transact({'from': minerAddr})
        return 0

    def reset_aggregated_models(self, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        tx = contract.functions.reset_aggregated_models().transact({'from': minerAddr})
        return tx.hex()

    def get_global_model(self):
        return self.contract.functions.get_global_model().call()

    def set_global_model(self, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        return self.contract.functions.set_global_model().transact({'from': minerAddr})

    def start_next_round(self, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        tx = contract.functions.start_next_round().transact({'from': minerAddr})
        return tx.hex()

    def stop_training(self, minerAddr=None):
        minerAddr = self.minerAddr if minerAddr==None else minerAddr
        tx = contract.functions.stop_training().transact({'from': minerAddr})
        return tx.hex()




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
    w3 = util.getProvider(args.config)
    mycontract = FL_Contract(contract, w3.eth.accounts[0])
    
    # testing the functions of FL Contracts
    AddrToJoin = w3.eth.accounts[1]
    tx_sent = mycontract.join_a_group(AddrToJoin)
    print(tx_sent)
    tx_sent = mycontract.change_role(AddrToJoin, 'aggregator')
    print(tx_sent)
    tx_sent = mycontract.reset_aggregated_models()
    print(tx_sent)
    tx_sent = mycontract.start_next_round()
    print(tx_sent)
