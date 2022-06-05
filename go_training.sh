#!/bin/bash

# Start a Flower server
echo "Starting server"
python3 flower/server.py --server_address=$1 --rounds 1 --sample_fraction=1.0 --min_sample_size=2 --min_num_clients=2
