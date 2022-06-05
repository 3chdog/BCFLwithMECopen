from flwr.common import (
    Parameters,
    Weights,
    parameters_to_weights,
    weights_to_parameters,
)
import flwr.server.strategy.aggregate as aggregate
import contractAPI.FLContract as flc
import ipfsAPI.ipfstools as ip
import json
from contractAPI.utils import readJson_to_parameters, parameters_to_dict
from modelSelector import Krum


import datetime, shutil


def main():    

    flcc = flc.FL_Contract()
    models = flcc.get_ipfs_urls() #hashes
    results = [] #parameters

    for i in range(len(models)):
        #ptName = (datetime.datetime.now()).strftime("%m%d_%H%M%S%f")
        #ptName = "flower/tmp_subAggr_" + ptName
        ptName = 'flower/tmp_sub_aggregated_model'
        strip, _= ip.ipfsGetFile(models[i], ptName)
        #shutil.copyfile(ptName, 'flower/tmp_sub_aggregated_model')
        results.append((parameters_to_weights(readJson_to_parameters('flower/tmp_sub_aggregated_model')), 1))
    
    # use Krum to select good models
    tmpModelsList = [model[0] for model in results]
    results_selected = Krum(modelsList=tmpModelsList)
    results_selected = [(model, 1) for model in results_selected]

    
    aggregated_output = weights_to_parameters(aggregate.aggregate(results_selected))

    with open("flower/tmp_aggregated_model", "w") as f:
        f.truncate(0)
        jsondict = parameters_to_dict(aggregated_output)
        json.dump(jsondict, f)
        
    strip, _ = ip.ipfsAddFile("flower/tmp_aggregated_model")
    flcc.append_aggregated_models(strip)
    
    with open("aggregator.log", "w") as f:
        f.truncate(0)
        # f.write("output=" + str(aggregated_output))
        f.write("results_selected =" + str(results_selected))
        f.write("strip =" + str(strip))

if __name__ == "__main__":
    main()