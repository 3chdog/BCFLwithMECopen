#!/bin/bash

# Start a Flower server
echo "Starting server"
python3 flower/server.py --rounds 1 --sample_fraction=1.0 --min_sample_size=3 --min_num_clients=3