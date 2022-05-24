# Implement environment before you use BCFLwithMEC
  
## 1. Add BCFL image to your docker images
There are 2 ways to get the BCFL image: "download from the site below" or "build the image by bcfldockerfile"
### (1) Download bcflimage.tar
Download bcflimage.tar https://drive.google.com/file/d/17hp4wH5ACWqdlJ7HJNe0vaD1jEn1AVx_/view?usp=sharing
Run the command below to load image to your docker images:
'''
sudo docker load < bcflimage.tar
'''
### (2) Build bcflimage from bcfldockerfile
or you can build the image from "bcfldockerfile"
  

## 2. Build Eth docker for Ethereum main nodes
'''
./Infrastructures/Eth_MainNodes/Eth_setup.sh
'''
This will start a container with 1 bootnode and 3 ethereum full nodes and output a "EthMiner_config.json".
"EthMiner_config.json" includes the account addresses and IP of 3 ethereum nodes.
1 "Bootstrap" and 3 "geth --mine" will run in background of this container.
You can check the log in the container at:
/root/bootnode.log
/root/miner1.log
/root/miner2.log
/root/miner3.log
  
  
## 3. Build IPFS dockers for private IPFS
'''
./Infrastructures/IPFS_MainNodes/IPFS_setup.sh
'''
This will start 3 containers and there is 1 IPFS node in each container.
"IPFS daemon" will run in background of each container.
  
  
Then, your main environment is set up.
And keep going to build your trainer node on other machine or on the same machine.
  

## 4. Build Trainer docker with flower and IPFS 
  
  
  
# Restart Container if terminated
Use the commands below to restart if you have set up containers of Ethereum and IPFS before.
Run "./Infrastructures/Eth_MainNodes/Eth_startNodes.sh"
Run "./Infrastructures/IPFS_MainNodes/IPFS_reRunDockerIPFS.sh"
