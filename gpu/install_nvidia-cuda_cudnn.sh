#! /bin/sh

# Install CUDA
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
cat 7fa2af80.pub | sudo apt-key add -

wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt update

sudo apt install linux-generic
sudo apt install cuda nvidia-375

sudo apt remove linux-virtual
sudo apt autoremove

rm 7fa2af80.pub cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

# Write PATH into bash.
cat << EOF | sudo tee -a /etc/profile
# CUDA
export PATH=$PATH:/usr/local/cuda-8.0/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64
EOF

# Install cudnn
# Before execute below command, you have to download&set cudnn-8.0-linux-x64-v7.tgz. 
tar xzf cudnn-8.0-linux-x64-v7.tgz
sudo cp -a cuda/lib64/* /usr/local/lib/
sudo cp -a cuda/include/* /usr/local/include/
sudo ldconfig

rm -R -f cuda cudnn-8.0-linux-x64-v7.tgz