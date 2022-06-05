#!/bin/bash
read CONFPATH < configPath.txt
ETHMINER="eth_config.json"
CONFIG="Trainer_docker.conf"
PEERCONFIG="IPFS_mainPeers.conf"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[4]}

# ipfs init
sudo docker exec $CONTAINERNAME ipfs init
echo -e "\nIPFS init Finished!\n"
sudo docker exec $CONTAINERNAME ipfs bootstrap rm --all

# add IPFS bootstrap
sudo docker exec $CONTAINERNAME bash -c 'chmod 777 /root/BCFLwithMECopen/config/IPFS_mainPeers.conf && \
/root/BCFLwithMECopen/config/IPFS_mainPeers.conf'
sudo docker exec $CONTAINERNAME cp /root/BCFLwithMECopen/config/swarm.key /root/.ipfs/
echo ""
sudo docker exec $CONTAINERNAME bash -c 'ipfs daemon&'
sleep 3
sudo docker exec $CONTAINERNAME bash -c 'echo -e "\nList IPFS swarm peers:" && ipfs swarm peers'
