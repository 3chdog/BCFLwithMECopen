#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="IPFS_InfraDockers.conf"
INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)

# docker1
IDX=4
CONTAINERNAME=${INPUTS[IDX]}
echo -e "\nRestarting Docker: ${CONTAINERNAME}..."
sudo docker restart $CONTAINERNAME
echo "Starting IPFS daemon..."
sudo docker exec -d $CONTAINERNAME /bin/sh -c "ipfs daemon&"
# docker2
IDX=8
CONTAINERNAME=${INPUTS[IDX]}
echo -e "\nRestarting Docker: ${CONTAINERNAME}..."
sudo docker restart $CONTAINERNAME
echo "Starting IPFS daemon..."
sudo docker exec -d $CONTAINERNAME /bin/sh -c "ipfs daemon&"
# docker3
IDX=12
CONTAINERNAME=${INPUTS[IDX]}
echo -e "\nRestarting Docker: ${CONTAINERNAME}..."
sudo docker restart $CONTAINERNAME
echo "Starting IPFS daemon..."
sudo docker exec -d $CONTAINERNAME /bin/sh -c "ipfs daemon&"
