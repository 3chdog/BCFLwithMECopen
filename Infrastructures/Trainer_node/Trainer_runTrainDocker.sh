#!/bin/bash
echo -e "Remember to put 4 configurations inside \"config\" file:\n \
eth_config.json\n \
IPFS_mainPeers.conf\n \
swarm.key\n \
Trainer_docker.conf (You can use \"Trainer_docker_sample.conf\" as reference)\n\n"

read CONFPATH < configPath.txt
ETHMINER="eth_config.json"
CONFIG="Trainer_docker.conf"
IMAGE="trainerimage"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[4]}

# Docker port all the same number
HTTPportDocker=${INPUTS[1]}
SWARMPortDocker=${INPUTS[2]}
WEBPortDocker=${INPUTS[3]}

#sudo docker load < ipfsnodeimage.tar
IDX=5
HostPorts_Eth="${INPUTS[IDX+3]}-${INPUTS[IDX+4]}"
ContPorts_Eth="${INPUTS[IDX+3]}-${INPUTS[IDX+4]}"
HTTPportHost="${INPUTS[IDX]}"
SWARMPortHost="${INPUTS[IDX+1]}"
WEBPortHost="${INPUTS[IDX+2]}"

sudo docker run -idt -p $HostPorts_Eth:$ContPorts_Eth -p \
$HTTPportHost:$HTTPportDocker -p $SWARMPortHost:$SWARMPortDocker -p $WEBPortHost:$WEBPortDocker \
--name $CONTAINERNAME $IMAGE bash

# git clone in Host computer and cp into docker
REPONAME="BCFLwithMECopen"
sudo docker exec $CONTAINERNAME bash -c 'cd && git clone https://github.com/3chdog/BCFLwithMECopen'

echo "Please copy \"config\" into this docker."
echo "Try automative copying..."
echo "${CONFPATH}/."
sudo docker cp "${CONFPATH}/." "${CONTAINERNAME}:/root/${REPONAME}/config/"
sudo docker exec $CONTAINERNAME ls /root/
sudo docker exec $CONTAINERNAME ls /root/${REPONAME}/config