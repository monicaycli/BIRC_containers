#!/bin/bash
#build freesurfer with mpich and cuda-8.0 support

apt-get update
#Needs to be centos package even for ubuntu build
wget ftp://surfer.nmr.mgh.harvard.edu/pub/dist/fs_supportlibs/prebuilt/centos6_x86_64/centos6-x86_64-packages.tar.gz
tar -xzvf centos6-x86_64-packages.tar.gz
./centos6-x86_64-packages/setup.sh
rm centos6-x86_64-packages.tar.gz

apt-get install -y git-annex
git clone https://github.com/freesurfer/freesurfer.git
cd freesurfer
git remote add datasrc  https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/repo/annex.git
git fetch datasrc
git annex get --force --metadata fstags=makeinstall .

apt-get install -y build-essential \
            tcsh \
            libtool-bin \
            libtool \
            automake \
            gfortran \
            libglu1-mesa-dev \
            libfreetype6-dev \
            uuid-dev \
            libxmu-dev \
            libxmu-headers \
            libxi-dev \
            libx11-dev \
            libxml2-utils \
            libxt-dev \
            libjpeg62-dev \
            libxaw7-dev \
            liblapack-dev
apt-get install -y gcc-4.8 g++-4.8 libgfortran-4.8-dev
#previously gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.5) 

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

#forced to install vim for the xxd tool
apt-get install -y vim-common
apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

./setup_configure
./configure --disable-Werror --with-pkgs-dir=/tmp/downloads/centos6-x86_64-packages --disable-xawplus-apps  --disable-GUI-build --with-cuda=/usr/local/cuda-8.0 --enable-openmp  --with-mpi-include=/usr/lib/mpich/include/  --with-mpi-libraries=/usr/lib/mpich/lib/  --prefix=/usr/local/freesurfer_cuda 

make -j6

make install
