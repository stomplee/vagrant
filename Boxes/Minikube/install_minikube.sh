#!/bin/bash
 
if [ ! -f ~/runonce ]
then
 
  # Update the system
  apt-get update && apt-get upgrade -y

  # Download kubectl
  cd /home/ubuntu/
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

  # Mark the file as executable
  chmod +x kubectl

  # Move the file to a location in the path
  mv kubectl /usr/local/bin/kubectl

  # Download Minikube
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.2/minikube-linux-amd64

  # Mark the file as executable
  chmod +x minikube

  # Move the file to a location in the path
  mv minikube /usr/local/bin/

  touch ~/runonce
fi