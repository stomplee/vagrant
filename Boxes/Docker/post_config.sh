#!/bin/bash
 
if [ ! -f ~/runonce ]
then
 
  # Update the system
  apt-get update && apt-get upgrade -y

  # Install dependencies
  apt-get install apt-transport-https ca-certificates curl software-properties-common -y

  # Add Docker gpg key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # Add Docker repo to apt
  add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  apt-get update

  # Install docker
  apt-get install docker-ce -y

  # Add ubuntu user to docker group and restart docker service so you can run docker without sudo
  gpasswd -a ubuntu docker
  service docker restart

  # Test that docker works correctly by loading the hello-world image
  docker run hello-world
 
  touch ~/runonce
fi