from web3 import Web3
import os
import base64
import json
from dataclasses import dataclass
from typing import List
#from flwr.common.typing import Parameters # I define the class below to avoid circular import

# import data # where you define your model

####################
# for Path
def getConfigPath():
    utilPath = os.path.abspath(__file__)
    rootPath = os.path.dirname(os.path.dirname(os.path.dirname(utilPath)))
    return os.path.join(rootPath, "config", "eth_config.json")

# for Path
def get_baseDir(base="BCFLwithMEC"):
    file_path=os.path.abspath(__file__)

    bcflFolder = file_path
    limit_cycle = 10
    while limit_cycle>0:
        bcflFolder = os.path.dirname(bcflFolder)
        if os.path.basename(bcflFolder) == base:
            return bcflFolder
        limit_cycle -= 1

    print("Cannot get BCFLwithMEC folder. Return current path.")
    return file_path




####################
# for Geth
def getProvider(configPath, miner='miner1'):
    miner = 'miner1' if miner is None else miner
    configPath = getConfigPath() if configPath is None else configPath
    with open(configPath) as f:
        eth_config = json.load(f)
    minerUrl = eth_config["eth_nodes"][miner]["http"]
    return Web3(Web3.HTTPProvider(minerUrl))




####################
# for model saving json
@dataclass
class Parameters:
    """Model parameters."""

    tensors: List[bytes]
    tensor_type: str

# for model saving json
def parameters_to_dict(parameters: Parameters) -> dict:
    tensorEncodedList = []
    for tensor in parameters.tensors:
        # print("origin tensor")
        # print(tensor)
        tensor_b64 = base64.b64encode(tensor)
        # print("tensor B64")
        # print(tensor_b64)
        tensorEncode = tensor_b64.decode("utf-8")
        # print("UTF 8")
        # print(tensorEncode)
        tensorEncodedList.append(tensorEncode)
    
    writableJson = {"tensor_type": parameters.tensor_type, "tensors": tensorEncodedList}
    return writableJson

# for model saving json
def dict_to_parameters(dictJson:dict) -> Parameters:
    tensorsList = []
    for tensorEncoded in dictJson["tensors"]:
        tensor_b64 = tensorEncoded.encode("utf-8")
        tensor = base64.b64decode(tensor_b64)
        tensorsList.append(tensor)
    
    params = Parameters(tensors=tensorsList, tensor_type=dictJson["tensor_type"])
    return params

# for model saving json
def readJson_to_parameters(path: str) -> Parameters:
    with open(path, newline='') as jsonfile:
        dictJson = json.load(jsonfile)
    return dict_to_parameters(dictJson)