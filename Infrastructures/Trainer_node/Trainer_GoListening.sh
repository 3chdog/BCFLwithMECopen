#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="Trainer_docker.conf"
INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[4]}

sudo docker exec -it $CONTAINERNAME bash
#sudo docker exec $CONTAINERNAME bash -c '/root/BCFLwithMEC/listener_up.sh'
#sudo docker exec $CONTAINERNAME bash -c '/root/BCFLwithMEC/host.sh'