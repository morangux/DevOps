#!/bin/bash
#This script use to help with nvidia gpu driver in one command
#It supports ubuntu OS 18.04/20.04/22.04

GREEN='\033[0;32m'
NC='\033[0m'
# set -x

group="docker"

if grep -q $group /etc/group
then
    echo "${group} permissions cofigured!"
else
    echo "${group} does not exist"
    echo "configure docker permissions..."
    echo "please re run the script"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
fi

#*** installing docker
function install-docker {
        if [ -x "$(command -v docker)" ]
        then
                echo "Dockder already installed"
        else
                echo  -e "${GREEN} installing docker ${NC}"
                sudo apt update
                sudo apt install -y ca-certificates curl gnupg lsb-release
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update
                sudo DEBIAN_FRONTEND=noninteractive apt-get -y install docker-ce docker-ce-cli containerd.io > /dev/null
        fi
}

function install-cuda {
    if [ "${os_version}" == "1" ]
    then 
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
        sudo dpkg -i cuda-keyring_1.0-1_all.deb
        sudo apt-get update
        sudo apt-get -y install cuda
    elif [ "${os_version}" == "2" ]
    then 
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
        sudo dpkg -i cuda-keyring_1.0-1_all.deb
        sudo apt-get update
        sudo apt-get -y install cuda
    elif [ "${os_version}" == "3" ]
    then
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
        sudo dpkg -i cuda-keyring_1.0-1_all.deb
        sudo apt-get update
        sudo apt-get -y install cuda
    fi
}

function install-nvidia-docker {
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
	&& curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
	&& curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt-get update
	sudo apt-get install -y nvidia-docker2
	sudo systemctl restart docker
}


install-docker

cat <<EOF > /etc/docker/daemon.json
	{
	    "default-runtime": "nvidia",
	    "runtimes": {
	        "nvidia": {
	            "path": "/usr/bin/nvidia-container-runtime",
	            "runtimeArgs": []
	        }
	    }
	}
EOF

echo "Please select ubuntu OS (1-18.04,2-20.04,3-22.04)"
read os_version

install-cuda

install-nvidia-docker

if [ -x "$(command -v nvidia-smi)" ]
then 
    echo "nvidia drivers installed successfully"
else
    echo "installation of nvidia drivers failed"
fi

if [ -x "$(command -v nvidia-docker)" ]
then 
    echo "nvidia-docker installed successfully"
else
    echo "installation of nvidia-docker failed"
fi