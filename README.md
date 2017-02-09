# Vagrant Setup

1. Install latest Oracle Virtualbox
2. Install latest Vagrant
3. Run the command <code>vagrant plugin install vagrant-vbguest</code> to automatically install Virtualbox guest additions into vagrant machine
4. The Vagrantfiles have been configured with local static IPs, these may need to be changed to suit your environment
5. Inside the Vagrantfile is a line for the inline script which is commented out by default but when uncommented can be used to run post-deployment scripts
6. Vagrant has a bug that makes it run the post-deployment scripts multiple times.  To prevent that format your bash script like this:
	#!/bin/bash
	if [ ! -f ~/runonce ]
	then
		apt-get install python-pip -y
		pip install --upgrade pip
		apt-get install libssl-dev libffi-dev python-dev dos2unix python-apt -y
		hostname AnsibleControl
		pip2 install ansible-lint
	
	
		touch ~/runonce
	fi	
