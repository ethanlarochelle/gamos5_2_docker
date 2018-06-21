#!/bin/bash

source ./installGamosBaseDefs.sh $1 

mkdir $GAMOSREP
cd $GAMOSREP

export MYPWD=$PWD

export PLATFORM=$2
if [ $PLATFORM = "Ubuntu.16.10" -o $PLATFORM = "FedoraCore.25" ] ; then
  export LINUX_SYSTEM=Linux-g++
elif [ $PLATFORM = "MacOSX12" ]; then 
  export LINUX_SYSTEM=Darwin-g++
else 
  echo "!! Platform " $2 " is not supported in current GAMOS version. "
  echo "Supported platforms are Ubuntu.16.10 FedoraCore.25"
  exit
fi

echo @@@@@@ Installing GAMOS at $GAMOSREP
## Directory where you have put the tar ball containing the GAMOS installation

if [ "$3" = "" ] ; then
  is_curl=`which curl |wc -w`
  is_wget=`which wget |wc -w`

  if [ $is_curl = 1 ]; then
    echo "curl found, downloading binaries ..."
    export GAMOSFILES=$GAMOSREP
    echo CURL  http://fismed.ciemat.es/GAMOS/download/GAMOS.$GAMOS_VER/GAMOS.$GAMOS_VER.$PLATFORM.tgz
    curl -v --connect-timeout 30 -f -L -O http://fismed.ciemat.es/GAMOS/download/GAMOS.$GAMOS_VER/GAMOS.$GAMOS_VER.$PLATFORM.tgz
    curl -v --connect-timeout 30 -f -L -O http://fismed.ciemat.es/GAMOS/download/geant4.data.tar.gz
  elif [ $is_wget = 1]; then
    echo "wget found, downloading binaries ..."
    wget -N http://fismed.ciemat.es/GAMOS/download/GAMOS.$GAMOS_VER/GAMOS.$GAMOS_VER.$PLATFORM.tgz
    wget -N http://fismed.ciemat.es/GAMOS/download/geant4.data.tar.gz
  else  
    echo "!!! You need curl or wget installed in your system to download GAMOS binary files, so please install one of these first"
#    exit 1
  fi

else 
  export GAMOSFILES=$2
fi

echo Installing GAMOS version $GAMOS_VER...
tar zxf $GAMOSFILES/GAMOS.$GAMOS_VER.$PLATFORM.tgz
tar zxvf geant4.data.tar.gz

#echo Installing GEANT4 version $GEANT4_VER...
#echo Installing ROOT version $ROOT_VER...

cd $GAMOSREP
mv gamos/* .
rmdir gamos
cd $GAMOSREP/GAMOS.$GAMOS_VER/config 
OLDREP=/home/gamos/gamos
sed s:$OLDREP:$GAMOSREP:g confgamos.csh > ttt
mv ttt confgamos.csh
sed s:$OLDREP:$GAMOSREP:g confgamos.sh > ttt
mv ttt confgamos.sh

cd ../lib/$LINUX_SYSTEM
ls *.rootmap | 
while read filename; do
  sed s:$OLDREP:$GAMOSREP:g $filename > ttt
  mv ttt $filename
done  

cd $GAMOSREP

rm GAMOS.$GAMOS_VER.$PLATFORM.tgz

cd $MYPWD
