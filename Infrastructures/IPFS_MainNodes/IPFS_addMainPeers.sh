#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="IPFS_mainDockers.conf"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)

SWARMKEY=${INPUTS[NUM-1]}
# PeersConf generated by IPFS_configurePeerIDs.sh
PeersConf="IPFS_mainPeers.conf"
PeersConf="${CONFPATH}/${PeersConf}"

# docker1
IDX=4
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS docker:[${CONTAINERNAME}] to add bootstraps."
while read line; do sudo docker exec $CONTAINERNAME $line; done < $PeersConf
# set swarm.key
sudo docker cp swarm.key $CONTAINERNAME:/root/.ipfs/swarm.key
# start ipfs daemon
echo "Start ipfs daemon..."
echo "All ipfs peers:"
sudo docker exec -d $CONTAINERNAME /bin/sh -c "ipfs daemon&"
sudo docker exec $CONTAINERNAME ipfs swarm peers


# docker2
IDX=8
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS docker:[${CONTAINERNAME}] to add bootstraps."
while read line; do sudo docker exec $CONTAINERNAME $line; done < $PeersConf
# set swarm.key
sudo docker cp swarm.key $CONTAINERNAME:/root/.ipfs/swarm.key
# start ipfs daemon
echo "Start ipfs daemon..."
echo "All ipfs peers:"
sudo docker exec -d $CONTAINERNAME /bin/sh -c "ipfs daemon&"
sudo docker exec $CONTAINERNAME ipfs swarm peers


# docker3
IDX=12
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS docker:[${CONTAINERNAME}] to add bootstraps."
while read line; do sudo docker exec $CONTAINERNAME $line; done < $PeersConf
# set swarm.key
sudo docker cp swarm.key $CONTAINERNAME:/root/.ipfs/swarm.key
# start ipfs daemon
echo "Start ipfs daemon..."
echo "All ipfs peers:"
sudo docker exec -d $CONTAINERNAME /bin/sh -c "ipfs daemon&"
sudo docker exec $CONTAINERNAME ipfs swarm peers