#!/bin/bash

if [ ! -f ~/runonce ]
then
	
	git clone git://github.com/ansible/ansible.git --recursive /home/ubuntu/ansible
	apt-get install python-pip -y
	pip install --upgrade pip
	apt-get install libssl-dev libffi-dev python-dev dos2unix python-apt -y
	pip2 install ansible-lint
	
	
	touch ~/runonce
fi
