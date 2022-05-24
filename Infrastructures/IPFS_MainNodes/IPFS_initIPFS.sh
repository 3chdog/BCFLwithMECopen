#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="IPFS_mainDockers.conf"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)

# docker1
IDX=4
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS main docker:[${CONTAINERNAME}] to init IPFS."
sudo docker exec $CONTAINERNAME bash -c 'rm -rf ~/.ipfs'
sudo docker exec $CONTAINERNAME ipfs init
sudo docker exec $CONTAINERNAME ipfs bootstrap rm --all

# docker2
IDX=8
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS main docker:[${CONTAINERNAME}] to init IPFS."
sudo docker exec $CONTAINERNAME bash -c 'rm -rf ~/.ipfs'
sudo docker exec $CONTAINERNAME ipfs init
sudo docker exec $CONTAINERNAME ipfs bootstrap rm --all

# docker3
IDX=12
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS main docker:[${CONTAINERNAME}] to init IPFS."
sudo docker exec $CONTAINERNAME bash -c 'rm -rf ~/.ipfs'
sudo docker exec $CONTAINERNAME ipfs init
sudo docker exec $CONTAINERNAME ipfs bootstrap rm --all

# use docker1's swarm key
CONTAINERNAME=${INPUTS[4]}
sudo docker exec $CONTAINERNAME bash -c '/golang/bin/ipfs-swarm-key-gen > ~/.ipfs/swarm.key'
sudo docker cp $CONTAINERNAME:/root/.ipfs/swarm.key swarm.key