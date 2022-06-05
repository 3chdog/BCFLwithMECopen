#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="IPFS_InfraDockers.conf"
IMAGE="bcflimage"
INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)

# run this if you don't have the IPFS image
#sudo docker load < ipfsnodeimage.tar

# Docker port all the same number
HTTPportDocker=${INPUTS[1]}
SWARMPortDocker=${INPUTS[2]}
WEBPortDocker=${INPUTS[3]}

# docker1
IDX=4
CONTAINERNAME=${INPUTS[IDX]}
HTTPportHost=${INPUTS[IDX+1]}
SWARMPortHost=${INPUTS[IDX+2]}
WEBPortHost=${INPUTS[IDX+3]}
sudo docker run -idt -p $HTTPportHost:$HTTPportDocker -p $SWARMPortHost:$SWARMPortDocker -p $WEBPortHost:$WEBPortDocker --name $CONTAINERNAME $IMAGE bash

# docker2
IDX=8
CONTAINERNAME=${INPUTS[IDX]}
HTTPportHost=${INPUTS[IDX+1]}
SWARMPortHost=${INPUTS[IDX+2]}
WEBPortHost=${INPUTS[IDX+3]}
sudo docker run -idt -p $HTTPportHost:$HTTPportDocker -p $SWARMPortHost:$SWARMPortDocker -p $WEBPortHost:$WEBPortDocker --name $CONTAINERNAME $IMAGE bash

# docker3
IDX=12
CONTAINERNAME=${INPUTS[IDX]}
HTTPportHost=${INPUTS[IDX+1]}
SWARMPortHost=${INPUTS[IDX+2]}
WEBPortHost=${INPUTS[IDX+3]}
sudo docker run -idt -p $HTTPportHost:$HTTPportDocker -p $SWARMPortHost:$SWARMPortDocker -p $WEBPortHost:$WEBPortDocker --name $CONTAINERNAME $IMAGE bash