from web3 import Web3
import json
import os

def getConfigPath():
    utilPath = os.path.abspath(__file__)
    rootPath = os.path.dirname(os.path.dirname(os.path.dirname(utilPath)))
    return os.path.join(rootPath, "config", "eth_config.json")

def getProvider(configPath, miner='miner1'):
    miner = 'miner1' if miner is None else miner
    configPath = getConfigPath() if configPath is None else configPath
    with open(configPath) as f:
        eth_config = json.load(f)
    minerUrl = eth_config["eth_nodes"][miner]["http"]
    return Web3(Web3.HTTPProvider(minerUrl))
