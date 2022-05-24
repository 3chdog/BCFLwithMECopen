for CONTAINER in $@;
do
	sudo docker stop $CONTAINER
	sudo docker rm $CONTAINER
done
sudo docker ps -a | head
