#!/bin/bash
read CONFPATH < configPath.txt
ETHMINER="eth_config.json"
CONFIG="Trainer_docker.conf"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[4]}

sudo docker exec $CONTAINERNAME bash -c 'cd /root/BCFLwithMECopen && \
HASH=$(python3 flower/get_init_parameters.py) && \
HASH=($HASH) && HASH=${HASH[-1]} && \
echo "init model uploaded to IPFS: ${HASH}" && \
sed -i "s/QmTtvUpZcChmbKf2L2gexxxBbNwAvjhLBRHj4MVY1rqgHy/${HASH}/1" /root/BCFHwithMECopen/contracts/FL.sol'
