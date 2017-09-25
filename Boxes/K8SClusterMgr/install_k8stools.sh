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

# Download kubectl
echo "Installing kubectl"
cd "$WORKDIR"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

# Mark the file as executable
chmod +x kubectl

# Move the file to a location in the path
mv kubectl /usr/local/bin/kubectl
echo "Verifying that kubectl works correctly..."
kubectl version
echo "You should see a kubectl version output above.  If not kubectl did not install correctly."

echo "Downloading and installing CFSSL..."
# Download CFSSL (CloudFlare's PKI Toolkit) to handle PKI
wget --https-only https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O "$WORKDIR"/cfssl_linux-amd64
wget --https-only https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O "$WORKDIR"/cfssljson_linux-amd64

# Mark the scripts as executable
chmod +x "$WORKDIR"/cfssl_linux-amd64 "$WORKDIR"/cfssljson_linux-amd64

# Move the scripts to /usr/local/bin/
mv "$WORKDIR"/cfssl_linux-amd64 /usr/local/bin/cfssl
mv "$WORKDIR"/cfssljson_linux-amd64 /usr/local/bin/cfssljson

# Verify CFSSL is working
echo "Verifying that CFSSL is working..."
cfssl version
echo "You should see a cfssl version output above.  If not then CFSSL did not install correctly."

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

# Create SSL CSR
cat  << 'EOF' > "$WORKDIR"/ca-csr.json
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}
EOF

# Generate SSL certificates
echo "Generating CA certificate and private key..."
cfssl gencert -initca "$WORKDIR"/ca-csr.json | cfssljson -bare ca
ls "$WORKDIR"
echo "If the CA certificate and private key were created successfully, you should see ca.pem and ca-key.pem in the output above."

# Ensure the script has only been run once on this host
echo "install_k8stools.sh has already been run from this location." > "$WORKDIR"/install_k8stools-output.txt