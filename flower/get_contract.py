import argparse

from contractAPI.getContract import get_contract
from contractAPI import utils

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
    contract = get_contract(args.config, args.contrjson, args.contrtxjson, args.miner)

    
    w3 = utils.getProvider(args.config, args.miner)