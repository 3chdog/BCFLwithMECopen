#!/bin/bash

set -e

SERVER_ADDRESS=$1
NUM_CLIENTS=2

echo "Starting $NUM_CLIENTS clients."
for ((i = 0; i < $NUM_CLIENTS; i++))
do
    echo "Starting client(cid=$i) with partition $i out of $NUM_CLIENTS clients."
    python3 flower/client.py \
      --cid=$i \
      --server_address=$SERVER_ADDRESS &
done
echo "Started $NUM_CLIENTS clients."