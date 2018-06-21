apt-get -y install curl wget unzip git vim
apt-get -y install g++
apt-get -y install dpkg-dev
apt-get -y install libx11-dev
apt-get -y install libxpm-dev
apt-get -y install libpng12-dev libfreetype6-dev
apt-get -y install libxft-dev
apt-get -y install libxext-dev
apt-get -y install freeglut3-dev libglfw3-dev libglfw3 libglu1-mesa-dev mesa-common-dev libxmu-dev libxi-dev
apt-get -y install libxmu-dev
apt-get -y install libxi-dev
apt-get -y install cmake
apt-get -y install libafterimage-dev
apt-get -y install build-essential
apt-get -y install libtiff5-dev
apt-get -y install libjpeg8-dev
apt-get -y install python3
apt-get -y install gfortran libfftw3-dev
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
