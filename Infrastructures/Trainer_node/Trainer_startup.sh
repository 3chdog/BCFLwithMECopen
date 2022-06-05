echo -e "------ Build Container for Trainer ------\n\n"
echo -e "reading Trainer_docker.conf...\n"
./Trainer_runTrainDocker.sh
echo -e "------ Init IPFS on TrainerNode ------\n\n"
./Trainer_initIPFS.sh
echo -e "------ Get Init model and upload to IPFS ------\n\n"
echo "note: This will use IPFS."
./Trainer_modelInit.sh
echo -e "------ Deploy Contract ------\n\n"
./Trainer_deployContract.sh
