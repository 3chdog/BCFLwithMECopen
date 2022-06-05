import argparse
import contractAPI.deployContract as deployContract

def argparse_for_main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=str, required=False)
    parser.add_argument('--miner', type=str, required=False)
    parser.add_argument('--sol', type=str, required=True)
    args = parser.parse_args()
    return args

if __name__ == "__main__":
    args = argparse_for_main()
    deployContract.deploy_contract_with_sol(args.config, args.sol, args.miner)