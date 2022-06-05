from web3 import Web3
import argparse
import json

from . import utils
#python3 getContract.py --config <miner_address.json> --contrjson <contrjson.json> --contrtxjson <contrtxjson.json>

# This is automation for connection of deployContract.py and getContract.py
def get_contr_tx_json_name(contrjson_path):
    contrTxJson = contrjson_path.split('.')[0] + '_deployed_tx_receipt.json'
    return contrTxJson

def get_contract(config, contrJson, contrTxJson=None, miner=None):
    contrTxJson = get_contr_tx_json_name(contrJson) if contrTxJson is None else contrTxJson

    with open(contrJson) as f:
        contract_json = json.load(f)
    with open(contrTxJson) as f:
        TxJson = json.load(f)

    w3 = utils.getProvider(config, miner)

    # get Contract by contract_name, contract_address, and abi
    contract_name = [*contract_json][0]
    contract_address = TxJson["contractAddress"]
    contract=w3.eth.contract(address=contract_address, abi=contract_json[contract_name]["abi"])
    return contract



def argparse_for_main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=str, required=False)
    parser.add_argument('--miner', type=str, required=False)
    parser.add_argument('--contrjson', type=str, required=True)
    parser.add_argument('--contrtxjson', type=str, required=False)
    args = parser.parse_args()
    return args

#執行完deployContract.py，會產生兩個檔案：mymath_contract.json與mymath_contract_tx_recipe.json
#將以下兩個路徑改成自己電腦中儲存的.json路徑
if __name__ == "__main__":
    args = argparse_for_main()
    contract = get_contract(args.config, args.contrjson, args.contrtxjson, args.miner)

    
    w3 = utils.getProvider(args.config, args.miner)
    # test call contract
    # print(contract.functions.reset_ipfs_urls().transact({'from': w3.eth.accounts[0]}).hex())
    # print(contract.functions.reset_ipfs_urls().call())
