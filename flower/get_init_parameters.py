import json
from flwr.common.parameter import weights_to_parameters

import data
from ipfsAPI.ipfstools import ipfsAddFile
from contractAPI.utils import parameters_to_dict

#for model (before deploy contract)
def getInitParams():
    tmpModel = data.load_model()
    initParams = weights_to_parameters(tmpModel.get_weights())
    return initParams

if __name__=='__main__':
    initParams = getInitParams()
    initParams_dict = parameters_to_dict(initParams)

    with open("flower/init_model.pt", 'w') as f:
        json.dump(initParams_dict, f, indent=4)
    strip, _ = ipfsAddFile("flower/init_model.pt")
    print("Get init_model.pt and upload to IPFS at:")
    print(strip)