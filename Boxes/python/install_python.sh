#!/bin/bash

# Declare variables
WORKDIR=/home/ubuntu

# Check to make sure this script has not already been run on this host.
{
if [ -f "$WORKDIR"/install_python.txt ]; then
    echo "Script has already been run.  Exiting..."
    exit 0
fi
}

# Update the system and suppress any interactive menus that would halt the script
echo "Updating the system and suppressing interactive prompts..."
export DEBIAN_FRONTEND=noninteractive #required to suppress grub update popup which requires manual intervention otherwise.
apt-get update && apt-get upgrade -y
echo "System has been upgraded.  Continuing..."

# Install python 2.7
echo "Installing python 2.7..."
apt-get install python -y
python --version
echo "Should be a python version output above, if not python did not install correctly..."

# Ensure the script has only been run once on this host
echo "install_python.sh has already been run from this location." > "$WORKDIR"/install_python.txt