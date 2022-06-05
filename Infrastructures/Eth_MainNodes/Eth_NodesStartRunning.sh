#!/bin/bash
read CONFPATH < configPath.txt
CONFIG="Eth_InfraDockers.conf"
INPUTS=""
while read line;
do input=($line); INPUTS="${INPUTS} ${input[1]}";break;done < "${CONFPATH}/${CONFIG}"
echo $INPUTS
INPUTS=($INPUTS)
CONTAINERNAME=${INPUTS[0]}
sudo docker restart $CONTAINERNAME

# bootnode
sudo docker exec $CONTAINERNAME bootnode --genkey=/root/boot.key
sudo docker exec $CONTAINERNAME /bin/sh -c 'bootnode --verbosity 9 --nodekey=/root/boot.key 2>>/root/bootnode.log&'

sleep 2
# Eth_InfraDockers.conf (remember to edit the name)
# miner1 (just change the number of MINERNUM=1)
sudo docker exec $CONTAINERNAME bash -c 'MINERNUM=1 && \
MINER="miner${MINERNUM}" && INPUTS="" && \
while read line; do input=($line); INPUTS="${INPUTS} ${input[1]}";done < /root/Eth_InfraDockers.conf && \
INPUTS=($INPUTS)
\
echo "starting [$MINER]..." && \
BOOTKEY=$(bootnode -writeaddress -nodekey=/root/boot.key) && \
echo Bootkey: $BOOTKEY && \
MINERADDR=$(cat /root/$MINER/data/keystore/UTC*) && \
echo Miner Addr: ${MINERADDR:12:40} && \
\
HTTPPort=${INPUTS[(MINERNUM-1)*2+1]}
WSPort=${INPUTS[(MINERNUM-1)*2+2]}
echo "using ports: http->$HTTPPort, ws->$WSPort"
\
geth --mine --miner.threads=2 \
--miner.gasprice=0 --syncmode "full" --networkid 66 \
--bootnodes enode://$BOOTKEY@127.0.0.1:30301 \
--datadir /root/$MINER/data  --unlock ${MINERADDR:12:40} \
--password /root/mypasswd.txt \
--http --http.addr 0.0.0.0  --http.corsdomain "*" \
--http.api "admin,eth,net,web3,personal,miner" \
--ws --ws.addr 0.0.0.0 --port $((30302+MINERNUM)) --ws.origins "*" \
--ws.api "eth,net,web3" \
--nousb --allow-insecure-unlock \
--http.port $HTTPPort --ws.port $WSPort \
2>>/root/$MINER.log&'

# miner2
sudo docker exec $CONTAINERNAME bash -c 'MINERNUM=2 && \
MINER="miner${MINERNUM}" && INPUTS="" && \
while read line; do input=($line); INPUTS="${INPUTS} ${input[1]}";done < /root/Eth_InfraDockers.conf && \
INPUTS=($INPUTS)
\
echo "starting [$MINER]..." && \
BOOTKEY=$(bootnode -writeaddress -nodekey=/root/boot.key) && \
echo Bootkey: $BOOTKEY && \
MINERADDR=$(cat /root/$MINER/data/keystore/UTC*) && \
echo Miner Addr: ${MINERADDR:12:40} && \
\
HTTPPort=${INPUTS[(MINERNUM-1)*2+1]}
WSPort=${INPUTS[(MINERNUM-1)*2+2]}
echo "using ports: http->$HTTPPort, ws->$WSPort"
\
geth --mine --miner.threads=2 \
--miner.gasprice=0 --syncmode "full" --networkid 66 \
--bootnodes enode://$BOOTKEY@127.0.0.1:30301 \
--datadir /root/$MINER/data  --unlock ${MINERADDR:12:40} \
--password /root/mypasswd.txt \
--http --http.addr 0.0.0.0  --http.corsdomain "*" \
--http.api "admin,eth,net,web3,personal,miner" \
--ws --ws.addr 0.0.0.0 --port $((30302+MINERNUM)) --ws.origins "*" \
--ws.api "eth,net,web3" \
--nousb --allow-insecure-unlock \
--http.port $HTTPPort --ws.port $WSPort \
2>>/root/$MINER.log&'

# miner3
sudo docker exec $CONTAINERNAME bash -c 'MINERNUM=3 && \
MINER="miner${MINERNUM}" && INPUTS="" && \
while read line; do input=($line); INPUTS="${INPUTS} ${input[1]}";done < /root/Eth_InfraDockers.conf && \
INPUTS=($INPUTS)
\
echo "starting [$MINER]..." && \
BOOTKEY=$(bootnode -writeaddress -nodekey=/root/boot.key) && \
echo Bootkey: $BOOTKEY && \
MINERADDR=$(cat /root/$MINER/data/keystore/UTC*) && \
echo Miner Addr: ${MINERADDR:12:40} && \
\
HTTPPort=${INPUTS[(MINERNUM-1)*2+1]}
WSPort=${INPUTS[(MINERNUM-1)*2+2]}
echo "using ports: http->$HTTPPort, ws->$WSPort"
\
geth --mine --miner.threads=2 \
--miner.gasprice=0 --syncmode "full" --networkid 66 \
--bootnodes enode://$BOOTKEY@127.0.0.1:30301 \
--datadir /root/$MINER/data  --unlock ${MINERADDR:12:40} \
--password /root/mypasswd.txt \
--http --http.addr 0.0.0.0  --http.corsdomain "*" \
--http.api "admin,eth,net,web3,personal,miner" \
--ws --ws.addr 0.0.0.0 --port $((30302+MINERNUM)) --ws.origins "*" \
--ws.api "eth,net,web3" \
--nousb --allow-insecure-unlock \
--http.port $HTTPPort --ws.port $WSPort \
2>>/root/$MINER.log&'
