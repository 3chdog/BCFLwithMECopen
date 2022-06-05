#!/bin/bash
# get ports
read CONFPATH < configPath.txt
CONFIG="Eth_InfraDockers.conf"
INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[0]}

# get IP address
CONFIG_IP="IPFS_InfraDockers.conf"
read CONFIPPATH < "${CONFPATH}/${CONFIG_IP}"
CONFIPPATH=($CONFIPPATH)
IP=${CONFIPPATH[1]}

# start new EthMiner_config.json
OUTPUTCONF="eth_config.json"
echo -n "" > "${CONFPATH}/${OUTPUTCONF}"
echo -e "\
{
  \"eth_nodes\":{" >> "${CONFPATH}/${OUTPUTCONF}"


# miner1
MINERNUM=1
PORT=${INPUTS[(MINERNUM-1)*2+1]}
CMD="bash -c 'cat /root/miner$MINERNUM/data/keystore/UTC*'"
MINERADDR=$(/bin/sh -c "sudo docker exec $CONTAINERNAME $CMD")
MINERADDR=${MINERADDR:12:40}
echo "Miner${MINERNUM} Address: ${MINERADDR}"

echo -e "\
    \"miner${MINERNUM}\": {
      \"http\":\"http://${IP}:${PORT}\",
      \"account1\": {
        \"address\":\"${MINERADDR}\",
        \"private_key\":\"none\"
      }
    }," >> "${CONFPATH}/${OUTPUTCONF}"


# miner2
MINERNUM=2
PORT=${INPUTS[(MINERNUM-1)*2+1]}
CMD="bash -c 'cat /root/miner$MINERNUM/data/keystore/UTC*'"
MINERADDR=$(/bin/sh -c "sudo docker exec $CONTAINERNAME $CMD")
MINERADDR=${MINERADDR:12:40}
echo "Miner${MINERNUM} Address: ${MINERADDR}"

echo -e "\
    \"miner${MINERNUM}\": {
      \"http\":\"http://${IP}:${PORT}\",
      \"account1\": {
        \"address\":\"${MINERADDR}\",
        \"private_key\":\"none\"
      }
    }," >> "${CONFPATH}/${OUTPUTCONF}"


# miner3
MINERNUM=3
PORT=${INPUTS[(MINERNUM-1)*2+1]}
CMD="bash -c 'cat /root/miner$MINERNUM/data/keystore/UTC*'"
MINERADDR=$(/bin/sh -c "sudo docker exec $CONTAINERNAME $CMD")
MINERADDR=${MINERADDR:12:40}
echo "Miner${MINERNUM} Address: ${MINERADDR}"

echo -e "\
    \"miner${MINERNUM}\": {
      \"http\":\"http://${IP}:${PORT}\",
      \"account1\": {
        \"address\":\"${MINERADDR}\",
        \"private_key\":\"none\"
      }
    }" >> "${CONFPATH}/${OUTPUTCONF}" # last account should be no comma


# ending of EthMiner_config.json
echo -e "\
  }\n\
}" >> "${CONFPATH}/${OUTPUTCONF}"



echo "\"eth_config.json\" finished!"
echo "Please check config/eth_config.json."