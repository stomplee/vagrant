# Vagrant Setup

1. Install latest Oracle Virtualbox
2. Install latest Vagrant
3. Run the command <code>vagrant plugin install vagrant-vbguest</code> to automatically install Virtualbox guest additions into vagrant machine
4. The Vagrantfiles have been configured with local static IPs, these may need to be changed to suit your environment
5. Inside the Vagrantfile is a line for the inline script which is commented out by default but when uncommented can be used to run post-deployment scripts
