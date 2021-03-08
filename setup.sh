#!/usr/bin/env bash

echo -e "\e[1;31m configure Hosts file for your enviroment  \e[0m"
sudo echo -e "10.10.20.10  kongdatastore \n10.10.20.11    kongnode01 \n10.10.20.12    kongnode02" >> /etc/hosts

echo -e "\e[1;31m change sshd config for vagrant box and restart service  \e[0m"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/UseDNS no/UseDNS yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo -e "\e[1;31m change root pass  \e[0m"
sudo echo "root" | sudo passwd --stdin root

echo -e "\e[1;31m install requered packages  \e[0m"
sudo yum update -y
## Install epel repo and then install jq
sudo yum install epel-release -y && yum install jq -y 

## Install docker-ce related packages
sudo yum install yum-utils device-mapper-persistent-data lvm2 git -y

## Enable docker-ce repo and install docker engine.
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl enable docker && sudo systemctl start docker

## Install latest docker-compose
LATEST_VERSION=$(sudo curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
sudo curl -L "https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo -e "\e[1;31m disable Swap  for kubernetes  \e[0m"
sudo swapoff -a
sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
echo -e "\e[1;31m disbale Firewall and Selinux  \e[0m"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config