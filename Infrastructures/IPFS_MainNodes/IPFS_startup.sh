echo -e "------ Build Containers for Main IPFS ------\n\n"
echo -e "reading ipfs_mainDockers.conf...\n"
./IPFS_runMainDockers.sh
echo -e "------ Init IPFS ------\n\n"
./IPFS_initIPFS.sh
echo -e "------ Configure IPFS Peers to ipfs_mainPeers.conf ------\n\n"
./IPFS_configurePeerIDs.sh
echo -e "------ Add peers from ipfs_mainPeers.conf and start IPFS daemon ------\n\n"
./IPFS_addMainPeers.sh
