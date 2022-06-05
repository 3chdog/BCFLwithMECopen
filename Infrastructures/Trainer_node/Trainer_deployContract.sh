#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="Trainer_docker.conf"
INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[4]}

sudo docker exec $CONTAINERNAME /root/BCFLwithMECopen/flower/deploy_Contract.sh