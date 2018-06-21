#!/bin/bash
export MYPWD=$PWD

source ./installGamosBaseDefs.sh $1

echo Installing ROOT VERSION $ROOT_VER 
cd $GAMOSREP/external/root/$ROOT_VER/
cd  root
echo $PWD 

export ROOTSYS=$GAMOSREP/external/root/$ROOT_VER/root
./configure --enable-builtin-freetype --enable-builtin-afterimage
if [ `uname` == "Linux" ] ; then
./configure --enable-builtin-freetype --disable-fftw3 --enable-builtin-afterimage --disable-asimage
elif [  `uname` == "Darwin" ] ; then
# to compile on 64-bits mode 
./configure macosx64
fi

make -j2


cd $MYPWD
