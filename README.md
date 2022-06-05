### CONCURRENT OWNERSHIP: @3chdog @tcfwbper @lukehu-nctu

# BCFLwithMEC
Term Project of Blockchain class  
  
  
# How to use (Not including Infrastructure setup)
Guide you to deploy FL.sol and run the example of 2 flower servers.  
BE AWARE: """ cd ~/BCFLwithMEC """  
BE AWARE: All commands running at BCFLwithMEC folder.  

## 0. Prepare your config and IPFS
"eth_config.json" must be in the folder of config.  
You should run "ipfs daemon" on another terminal before using this.  

## 1. deploy your contract
```
./flower/deploy_Contract.sh
```
It will deploy contracts/FL.sol, and generate 2 json file:  
FL.json                       | info of "abi"  
FL_deployed_tx_receipt.json   | info of tx_hash of the transaction that FL.sol deployed on  

## 2. Start-up a listener with a flower server
```
./listener_up.sh
```
This will run a flower server and 3 flower clients after step 3 (below).  

## 3. Start-up second listener with another flower server
```
./listener_up.sh
```
This will run another flower server and 3 other flower clients.  
  
  
# Details
## 1. Blockchain: Go Ethereum

### (1) Eth Nodes
Now two nodes in the "eth_config"

### (2) Contracts
Implement flower server

### (3) IPFS
Now doing...

## 2. Federated Learning: flower 0.18.0
https://github.com/adap/flower  
edit flower client to fit Blockchain  

## 3. MEC