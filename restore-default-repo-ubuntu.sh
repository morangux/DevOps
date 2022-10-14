#This script can help to restore ubuntu repository to its default configuration
#!/bin/bash
#Please run this script as ROOT

GREEN='\033[0;32m'
NC='\033[0m'
# set -x

function backup_repo {
    cd /etc/apt
    sudo mv sources.list sources.list.bk
}

function create_repo {


cd /etc/apt
cat <<EOF > sources.list
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://archive.canonical.com/ubuntu focal partner
deb-src http://archive.canonical.com/ubuntu focal partner
EOF
sudo apt update
sudo gpg --keyserver pgpkeys.mit.edu --recv-key 3B4FE6ACC0B21F32
sudo gpg -a --export 3B4FE6ACC0B21F32 | sudo apt-key add -
sudo gpg --keyserver pgpkeys.mit.edu --recv-key 871920D1991BC93C
sudo gpg -a --export 871920D1991BC93C | sudo apt-key add -
sudo apt-get update

}

backup_repo
create_repo
echo -e "${GREEN}Repository has been restored!${NC}"
