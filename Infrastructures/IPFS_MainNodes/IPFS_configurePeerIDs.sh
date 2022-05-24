#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="IPFS_mainDockers.conf"
INPUTS=""
NUM=0
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";let "NUM++";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)

HostIP=${INPUTS[0]}

# make a txt file for PeerIDs
PeersConf="IPFS_mainPeers.conf"
PeersConf="${CONFPATH}/${PeersConf}"
[ ! -e $PeersConf ] || rm $PeersConf
touch $PeersConf
sudo chmod u=rw $PeersConf

# docker1
IDX=4
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS main docker:[${CONTAINERNAME}] to configure IPFS peer."
sudo docker exec $CONTAINERNAME bash -c 'rm -r /root/.ipfs/PeerID'
sudo docker exec $CONTAINERNAME bash -c 'while read line; do input=($line); \
if [ "${input[0]}" = "\"PeerID\":" ]; then PeerID=${input[1]:1:52}; break; fi; \
done < /root/.ipfs/config && \
echo IPFS_ID: $PeerID &&\
echo "$PeerID" >> /root/.ipfs/PeerID'
# edit PeerID to bootstrap line
sudo docker cp $CONTAINERNAME:/root/.ipfs/PeerID "PeerID_${IDX}"
while read line; do input=($line); done < "PeerID_${IDX}"
echo "ipfs bootstrap add /ip4/${HostIP}/tcp/${SWARMPortDocker}/ipfs/${input}" >> $PeersConf

# docker2
IDX=8
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS main docker:[${CONTAINERNAME}] to configure IPFS peer."
sudo docker exec $CONTAINERNAME bash -c 'rm -r /root/.ipfs/PeerID'
sudo docker exec $CONTAINERNAME bash -c 'while read line; do input=($line); \
if [ "${input[0]}" = "\"PeerID\":" ]; then PeerID=${input[1]:1:52}; break; fi; \
done < /root/.ipfs/config && \
echo IPFS_ID: $PeerID &&\
echo "$PeerID" >> /root/.ipfs/PeerID'
# edit PeerID to bootstrap line
sudo docker cp $CONTAINERNAME:/root/.ipfs/PeerID "PeerID_${IDX}"
while read line; do input=($line); done < "PeerID_${IDX}"
echo "ipfs bootstrap add /ip4/${HostIP}/tcp/${SWARMPortDocker}/ipfs/${input}" >> $PeersConf

# docker3
IDX=12
CONTAINERNAME=${INPUTS[IDX]}
SWARMPortDocker=${INPUTS[IDX+2]}
echo -e "\n\nIPFS main docker:[${CONTAINERNAME}] to configure IPFS peer."
sudo docker exec $CONTAINERNAME bash -c 'rm -r /root/.ipfs/PeerID'
sudo docker exec $CONTAINERNAME bash -c 'while read line; do input=($line); \
if [ "${input[0]}" = "\"PeerID\":" ]; then PeerID=${input[1]:1:52}; break; fi; \
done < /root/.ipfs/config && \
echo IPFS_ID: $PeerID &&\
echo "$PeerID" >> /root/.ipfs/PeerID'
# edit PeerID to bootstrap line
sudo docker cp $CONTAINERNAME:/root/.ipfs/PeerID "PeerID_${IDX}"
while read line; do input=($line); done < "PeerID_${IDX}"
echo "ipfs bootstrap add /ip4/${HostIP}/tcp/${SWARMPortDocker}/ipfs/${input}" >> $PeersConf
