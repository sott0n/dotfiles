#! /bin/sh

# Install nvidia-docker
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb
rm /tmp/nvidia-docker*.deb

# Build docker file
sudo nvidia-docker build -t gpu-machine docker
sudo nvidia-docker run -d -v $HOME/:/src -p 8888:8888 -name gpu-work gpu-machine
sudo nvidia-docker exec -it gpu-work /bin/bash