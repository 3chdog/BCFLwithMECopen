#!/bin/bash
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
# Will turn into asking docker to git clone after the repo becomes open
# rm -rf ./BCFLwithMEC
# git clone https://github.com/3chdog/BCFLwithMEC

sudo docker cp /home/jack/jacklab/blockchain/BCFLwithMEC $CONTAINERNAME:/root/
sudo docker exec $CONTAINERNAME rm -rf /root/BCFLwithMEC/config
sudo docker cp $CONFPATH $CONTAINERNAME:/root/BCFLwithMEC/
