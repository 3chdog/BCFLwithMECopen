#!/bin/bash

python3 flower/contractAPI/deployContract.py \
--sol contracts/FL.sol \
--config config/eth_config.json \
--miner miner1
