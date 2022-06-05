#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="Eth_InfraDockers.conf"
IMAGE="bcflimage"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[0]}

#sudo docker load < ipfsnodeimage.tar
lastport="${INPUTS[6]}"
hostports="${INPUTS[1]}-${lastport}"
contports="${INPUTS[1]}-${lastport}"
sudo docker run -idt -p $hostports:$contports --name $CONTAINERNAME $IMAGE bash