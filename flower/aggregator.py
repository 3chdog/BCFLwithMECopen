from flwr.common import (
    Parameters,
    Weights,
    parameters_to_weights,
    weights_to_parameters,
)
import flwr.server.strategy.aggregate as aggregate
import contractAPI.FLContract as flc
import ipfsAPI.ipfstools as ip
import jsons



def main():    

    flcc = flc.FL_Contract()
    models = flcc.get_ipfs_urls() #hashes
    results = [] #parameters

    for i in range(len(models)):
        strip, _= ip.ipfsCatFile(models[i])
        try:
            results.append((parameters_to_weights(jsons.loads(strip, Parameters)), 1))
        except:
            pass
    
    output = weights_to_parameters(aggregate.aggregate(results))

    f = open("flower/tmp_aggregated_model", "w")
    f.truncate(0)
    jsonstring = jsons.dumps(output)
    f.write(jsonstring)
    f.close()
    strip, _ = ip.ipfsAddFile("flower/tmp_aggregated_model")
    flcc.append_aggregated_models(strip)
    
    f = open("aggregator.log", "w")
    f.truncate(0)
    f.write("output=" + str(output))
    f.write("strip=" + str(strip))
    f.close()

if __name__ == "__main__":
    main()