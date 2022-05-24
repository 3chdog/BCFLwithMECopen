echo -e "------ Build Containers for Main Go-Ethereum Nodes ------\n\n"
echo -e "reading Eth_docker.conf...\n"
./Eth_runMainDockers.sh
echo -e "------ Init Ethereum ------\n\n"
./Eth_initMiner.sh
echo -e "------ Output Eth Miner Info for trainer ------\n\n"
./Eth_outputHTTPprovider.sh
echo -e "------ Run BootNode and Main Ethereum nodes ------\n\n"
./Eth_startNodes.sh
