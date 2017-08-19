#! /bin/sh

sudo apt update
sudo apt upgrade

# Install kernel compiler
sudo apt install -y linux-image-extra-virtual linux-source linux-headers-`uname -r`

# Install nvidia driver
wget http://jp.download.nvidia.com/XFree86/Linux-x86_64/375.66/NVIDIA-Linux-x86_64-375.66.run
chmod +x NVIDIA-Linux-x86_64-*.run
sudo ./`ls NVIDIA-Linux-x86_64-*.run | head -1`