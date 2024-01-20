#!/bin/bash

sudo yum update -y

# Install docker
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
rm minikube-latest.x86_64.rpm

echo 'alias kubectl="minikube kubectl --"' >> ${HOME}/.bashrc
echo 'alias k=kubectl' >> ${HOME}/.bashrc

# minikube start
# minikube addons enable ingress
