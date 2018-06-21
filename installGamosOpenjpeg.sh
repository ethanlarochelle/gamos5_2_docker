#!/bin/bash
if [ "$1" == "" ] ; then
  echo "%%%%%% ERROR: You have to put as first argument the directory where you want OPENJPEG for GAMOS to be installed"
  exit 1
else
  export GAMOSREP=$1
  export LINUX_SYSTEM=uncompiled
fi

export GAMOS_VER=5.2.0

export OPENJPEG_VER=2.1.1
mkdir -p $GAMOSREP/external/openjpeg

cd $GAMOSREP/external/openjpeg
echo @@@@@@@@@@@@ PWD $PWD

export GAMOSWEB=http://fismed.ciemat.es/GAMOS/download/GAMOS.$GAMOS_VER/$LINUX_SYSTEM

is_curl=`which curl |wc -w`
is_wget=`which wget |wc -w`

if [ $is_curl = 1 ]; then
  echo "curl found, downloading sources ..."
  curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/openjpeg-$OPENJPEG_VER.tar.gz
elif [ $is_wget = 1 ]; then
  echo "wget found, downloading sources ..."
  wget -N $GAMOSWEB/openjpeg-$OPENJPEG_VER.tar.gz
else
  echo "!!! You need curl or wget installed in your system to download GAMOS source files, so please install one of these first"
  echo 1 > $GAMOSREP/exit.code
  exit 1
fi

echo Installing OPENJPEG version $OPENJPEG_VER...
tar zxf openjpeg-$OPENJPEG_VER.tar.gz
cd  openjpeg-$OPENJPEG_VER
echo @@@@@@@@@@@@ PWD $PWD

echo @@@ cmake 
cmake -DCMAKE_BUILD_TYPE=Release .

echo @@@ make
make install

#rm ../../openjpeg-$OPENJPEG_VER.source.tar.gz


