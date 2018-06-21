#!/bin/bash
export MYPWD=$PWD

source ./installGamosBaseDefs.sh $1 

export LINUX_SYSTEM=uncompiled

mkdir $GAMOSREP
cd $GAMOSREP

echo @@@@@@ Installing GAMOS at $GAMOSREP
## Directory where you have put the tar ball containing the GAMOS installation
if [ "$2" = "" ]; then
  export GAMOSFILES=$GAMOSREP
  export GAMOSWEB=http://fismed.ciemat.es/GAMOS/download/GAMOS.$GAMOS_VER/$LINUX_SYSTEM

  is_curl=`which curl |wc -w`
  is_wget=`which wget |wc -w`

  if [ $is_curl = 1 ]; then
    echo "curl found, downloading sources ..."
    curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/GAMOS.$GAMOS_VER.tgz
    curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/geant4.$GEANT4_VER.tar.gz
    curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/geant4.$GEANT4_VER.data.tar.gz
    if [  `uname` == "Linux" ] ; then
      curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/root_v$ROOT_VER.source.tar.gz
    elif [  `uname` == "Darwin" ] ; then
      system_ver=`uname -r | sed 's/\([0-9]*\).[0-9]*.[0-9]*/\1/'`
      if [ $system_ver == "15" ] ; then
        curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/root_v$ROOT_VER.macosx64-10.11-clang70.tar.gz 
      elif [ $system_ver == "16" ] ; then
        echo "ROOT already installed with macports at /opt/local/libexec/root5"
      else
        echo "ONLY Mac OS X 10.11 El Capitan  or  Mac OS X 10.12 Sierra are supported "
        echo 1 > $GAMOSREP/exit.code
        exit
      fi  
    fi 
  elif [ $is_wget = 1 ]; then
    echo "wget found, downloading sources ..."
    wget -N $GAMOSWEB/GAMOS.$GAMOS_VER.tgz
    wget -N $GAMOSWEB/geant4.$GEANT4_VER.tar.gz
    wget -N $GAMOSWEB/geant4.$GEANT4_VER.data.tar.gz
    wget -N $GAMOSWEB/root_v$ROOT_VER.source.tar.gz
  else
    echo "!!! You need curl or wget installed in your system to download GAMOS source files, so please install one of these first"
    echo 1 > $GAMOSREP/exit.code
    exit 1
  fi

else 
  export GAMOSFILES=$2
fi

echo Installing GAMOS version $GAMOS_VER...
tar zxf $GAMOSFILES/GAMOS.$GAMOS_VER.tgz

echo Adding GAMOS version with Tissue Optics plugin
mkdir $HOME/backup
mv $GAMOSFILES/GAMOS.$GAMOS_VER/source/GamosCore $HOME/backup
wget -N https://github.com/ethanlarochelle/GamosCore/archive/5_2.zip
unzip 5_2.zip
mv GamosCore-5_2 GamosCore
mv GamosCore $GAMOSFILES/GAMOS.$GAMOS_VER/source/
rm 5_2.zip

mkdir -p external
cd external

echo Installing GEANT4 version $GEANT4_VER...
mkdir -p geant4
cd geant4
tar zxf $GAMOSFILES/geant4.$GEANT4_VER.tar.gz
tar zxf $GAMOSFILES/geant4.$GEANT4_VER.data.tar.gz
cd ..

echo Installing ROOT version $ROOT_VER...
mkdir -p root
mkdir root/$ROOT_VER
cd root/$ROOT_VER
if [ `uname` == "Linux" ] ; then
  tar zxf $GAMOSFILES/root_v$ROOT_VER.source.tar.gz
elif [ `uname` == "Darwin" ] ; then
  system_ver=`uname -r | sed 's/\([0-9]*\).[0-9]*.[0-9]*/\1/'`
  if [ $system_ver == "15" ] ; then
    tar zxf $GAMOSFILES/root_v$ROOT_VER.macosx64-10.11-clang70.tar.gz
  elif [ $system_ver == "16" ] ; then
    tar zxvf $GAMOSFILES/root_v$ROOT_VER.macosx64-10.12.tar.gz
  fi
fi
cd ../..

cd $MYPWD

source ./dependencySearch.sh
