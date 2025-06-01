#!/bin/bash

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "/etc/os-release not found. Cannot determine OS. Skipping."
    exit 1
fi

# Set docker repo and gpg for different distros
if [ "$ID" = "kali" ] || [ "$ID" = "debian" ]; then
    echo "Detected $ID. Using Debian Docker repository."
    DOCKER_GPG_URL="https://download.docker.com/linux/debian/gpg"
    if [ "$ID" = "kali" ]; then
        VERSION_CODENAME="bullseye"
    fi
    DOCKER_REPO="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
        https://download.docker.com/linux/debian ${VERSION_CODENAME} stable"
elif [ "$ID" = "ubuntu" ]; then
    echo "Detected Ubuntu. Using Ubuntu Docker repository."
    DOCKER_GPG_URL="https://download.docker.com/linux/ubuntu/gpg"
    DOCKER_REPO="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
        https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable"
else
    echo "Unsupported OS: $ID. Skipping."
    exit 1
fi

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "$DOCKER_GPG_URL" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "$DOCKER_REPO" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose:
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
