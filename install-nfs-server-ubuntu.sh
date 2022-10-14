#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'

function install-nfs-server {
    sudo apt install nfs-kernel-server -y
    sudo mkdir -p /mnt/"${nfs_server_share}"
    sudo chown -R nobody:nogroup /mnt/"${nfs_server_share}"/
    cd /mnt/"${nfs_server_share}"/
    sed -i -e '$a/mnt/"${nfs_server_share}"  nfs_server_ip/20(rw,sync,no_subtree_check)' /etc/exports
    sudo exportfs -a
    sudo systemctl restart nfs-kernel-server
}

function install-nfs-client {
    sudo apt install nfs-common
    sudo mkdir -p /mnt/"${nfs_client_share}"
    sudo chmod 777 -R /mnt/"${nfs_client_share}"
    sudo mount nfs_server_ip:/mnt/"${nfs_server_share}" /mnt/"${nfs_client_share}"/
    sed -i -e '$anfs_server_ip:/mnt/"${nfs_server_share}" /mnt/"${nfs_client_share}"/ nfs defaults,_netdev 0 0' /etc/fstab
}

nfs_server_ip="$(curl --silent ifconfig.co)"

echo -e "${GREEN}Please select installation type (1 - nfs server and nfs client , 2 - nfs server only , 3 - nfs client only)${NC}"
read ANSWER
if [ "${ANSWER}" == "1" ]
then 
    echo "please provide name for nfs server share directory:"
    read nfs_server_share
    # install-nfs-server
    echo "please provide name for nfs client share directory:"
    read nfs_client_share
    # install-nfs-client
elif [ "${ANSWER}" == "2" ]
then 
    echo "please provide name for nfs server share directory:"
    read nfs_server_share
    # install-nfs-server
elif [ "${ANSWER}" == "3" ]
then
    echo "please provide name for nfs client share directory:"
    read nfs_client_share
    # install-nfs-client
fi
