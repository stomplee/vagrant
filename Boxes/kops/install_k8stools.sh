#!/bin/bash

# Declare variables
WORKDIR=/home/ubuntu

# Check to make sure this script has not already been run on this host.
{
if [ -f "$WORKDIR"/install_k8stools-output.txt ]; then
    echo "Script has already been run.  Exiting....."
    exit 0
fi
}

# Update the system and suppress any interactive menus that would halt the script
echo "Updating the system and suppressing interactive prompts..."
export DEBIAN_FRONTEND=noninteractive #required to suppress grub update popup which requires manual intervention otherwise.
apt-get update && apt-get upgrade -y
echo "System has been upgraded.  Continuing..."

# Install AWS CLI
apt-get install python python-pip -y
pip install --upgrade pip
pip install --upgrade awscli
echo "AWS CLI has been installed.  You need to run aws configure on the machine to configure the AWS CLI."

# Download kubectl
echo "Installing kubectl.."
cd "$WORKDIR"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

# Mark the file as executable
chmod +x kubectl

# Move the file to a location in the path
mv kubectl /usr/local/bin/kubectl
echo "Verifying that kubectl works correctly..."
kubectl version
echo "You should see a kubectl version output above.  If not kubectl did not install correctly."

# Download and install kops
wget "https://github.com/kubernetes/kops/releases/download/1.7.0/kops-linux-amd64" -P $WORKDIR
chmod +x $WORKDIR/kops-linux-amd64
mv $WORKDIR/kops-linux-amd64 /usr/local/bin/kops