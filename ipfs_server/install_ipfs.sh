#!/bin/bash

wget https://dist.ipfs.io/go-ipfs/v0.12.2/go-ipfs_v0.12.2_linux-amd64.tar.gz
tar -xvzf go-ipfs_v0.12.2_linux-amd64.tar.gz
cd go-ipfs
sudo bash install.sh
cd ..
rm -rf go-ipfs
rm go-ipfs_v0.12.2_linux-amd64.tar.gz
ipfs --version