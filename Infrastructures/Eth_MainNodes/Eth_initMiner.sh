#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="Eth_docker.conf"
NETGENESIS="mynet.json"
NETGENESISPATH="${CONFPATH}/${NETGENESIS}"
NETGENESISPATHDOCKER="/root/${NETGENESIS}"
while read line; do input=($line); done < "${CONFPATH}/${CONFIG}"
PASSWD=${input[1]}

INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";break;done < "${CONFPATH}/${CONFIG}"
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[0]}
sudo docker cp "${CONFPATH}/${CONFIG}" $CONTAINERNAME:/root/Eth_docker.conf
sudo docker cp $NETGENESISPATH $CONTAINERNAME:$NETGENESISPATHDOCKER
PASSWDCMD="bash -c 'echo \"${PASSWD}\" > /root/mypasswd.txt'"
bash -c "sudo docker exec $CONTAINERNAME $PASSWDCMD"
sudo docker exec $CONTAINERNAME cat /root/mypasswd.txt

echo -e "\n\n-------------- New Account Miner1 --------------"
sudo docker exec $CONTAINERNAME geth --datadir /root/miner1/data --password /root/mypasswd.txt account new
echo -e "\n\n-------------- New Account Miner2 --------------"
sudo docker exec $CONTAINERNAME geth --datadir /root/miner2/data --password /root/mypasswd.txt account new
echo -e "\n\n-------------- New Account Miner3 --------------"
sudo docker exec $CONTAINERNAME geth --datadir /root/miner3/data --password /root/mypasswd.txt account new
echo -e "\n\n--------------- Net Init Miner1 ----------------"
sudo docker exec $CONTAINERNAME geth --datadir /root/miner1/data init $NETGENESISPATHDOCKER
echo -e "\n\n--------------- Net Init Miner2 ----------------"
sudo docker exec $CONTAINERNAME geth --datadir /root/miner2/data init $NETGENESISPATHDOCKER
echo -e "\n\n--------------- Net Init Miner3 ----------------"
sudo docker exec $CONTAINERNAME geth --datadir /root/miner3/data init $NETGENESISPATHDOCKER
