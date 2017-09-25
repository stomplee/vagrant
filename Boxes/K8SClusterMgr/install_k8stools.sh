#!/bin/bash

# Declare variables
WORKDIR=/home/ubuntu

# Vagrant specific section to make sure the inline script is not run multiple times due to Vagrant bug
{
if [ -f "$WORKDIR"/install_k8stools-output.txt ]; then
    echo "Script has already been run.  Exiting....."
    exit 0
fi
}

# Update the system and suppress any interactive menus that would halt the script
export DEBIAN_FRONTEND=noninteractive #required to suppress grub update popup which requires manual intervention otherwise.
apt-get update && apt-get upgrade -y



# Download kubectl
cd "$WORKDIR"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

# Mark the file as executable
chmod +x kubectl

# Move the file to a location in the path
mv kubectl /usr/local/bin/kubectl

# Download CFSSL (CloudFlare's PKI Toolkit) to handle PKI
wget --https-only https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O "$WORKDIR"/cfssl_linux-amd64
wget --https-only https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O "$WORKDIR"/cfssljson_linux-amd64

# Mark the scripts as executable
chmod +x "$WORKDIR"/cfssl_linux-amd64 "$WORKDIR"/cfssljson_linux-amd64

# Move the scripts to /usr/local/bin/
mv "$WORKDIR"/cfssl_linux-amd64 /usr/local/bin/cfssl
mv "$WORKDIR"/cfssljson_linux-amd64 /usr/local/bin/cfssljson

# Verify CFSSL is working
echo "Verify CFSSL is working..."
cfssl version
echo "Should see something like Version

# Create SSL certificate authority config file
cat  << 'EOF' > "$WORKDIR"/ca-config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

echo "" > "$WORKDIR"/install_k8stools-output.txt