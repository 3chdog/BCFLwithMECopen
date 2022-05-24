from web3 import Web3
import solcx
from solcx import compile_source
import os
import json
import argparse
try:
    import util
except:
    from . import util

# python3 deployCtc.py --sol <.sol>


# 讀取.sol並編譯
def compile_source_file(file_path, ver='0.8.9'):
    solcx.install_solc(version=ver)
    solcx.set_solc_version(ver)
    with open(file_path, 'r') as f:
        source = f.read()
        print(source)
    return solcx.compile_source(source)

# 事先設定好w3.eth.default_account，就可以用這個account作deploy
def deploy_contract(w3, contract_interface):
    tx_hash = w3.eth.contract(
        abi=contract_interface['abi'],
        bytecode=contract_interface['bin']).constructor().transact()
    print("TX_hash: {}".format(tx_hash))
    print("TX_hash: {}".format(tx_hash.hex()))

    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    address = tx_receipt['contractAddress']
    return tx_receipt, address

def set_jsons_Name(sol):
    # set the name of 2 json files: contract_deployed_json and contract_deployed_tx_receipt
    contract_source_path = sol
    contract_dirpath = os.path.dirname(contract_source_path)
    contract_name = os.path.basename(contract_source_path)
    contract_name = contract_name.split('.')[0]
    contract_deployed_json_name = os.path.join(contract_dirpath, contract_name + '.json')
    contract_deployed_tx_receipt_name = os.path.join(contract_dirpath, contract_name + '_deployed_tx_receipt.json')
    return contract_deployed_json_name, contract_deployed_tx_receipt_name, contract_source_path

def deploy_contract_with_sol(config, sol, miner=None):
    # set the name of 2 json files: contract_deployed_json and contract_deployed_tx_receipt
    contract_deployed_json_name, contract_deployed_tx_receipt_name, contract_source_path = set_jsons_Name(sol)

    # w3這個HTTPProvider物件提供了區塊鍊網路的基礎設施，如同Ganache與infura提供給我們的基礎設施
    # 「http://」是我起的node，連上這個node就能和區塊鍊網路溝通
    w3 = util.getProvider(config, miner)
    w3.eth.default_account = w3.eth.accounts[0]
    
    ## Compile Contract
    # 輸入自己的contract(.sol)，編譯好之後會有binary code與json檔，目前只存json檔
    compiled_sol = compile_source_file(contract_source_path)
    with open(contract_deployed_json_name, 'w') as f:
        json.dump(compiled_sol, f)
    contract_id, contract_interface = compiled_sol.popitem()
    print("Contract_ID:", contract_id) # ID是「<stdin>:mymath」

    ## Deploy Contract
    w3.geth.miner.start(2) # Deploy前要讓node開始挖礦，在PoW的鍊才能deploy
    tx_receipt, address = deploy_contract(w3, contract_interface)
    w3.geth.miner.stop()
    print(f'Deployed {contract_id} to: {address}\n')

    # 將transaction recipe儲存
    tx_receipt_json = json.loads(Web3.toJSON(tx_receipt))
    with open(contract_deployed_tx_receipt_name, 'w') as f:
        json.dump(tx_receipt_json, f)



def argparse_for_main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=str, required=False)
    parser.add_argument('--miner', type=str, required=False)
    parser.add_argument('--sol', type=str, required=True)
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = argparse_for_main()
    deploy_contract_with_sol(args.config, args.sol, args.miner)