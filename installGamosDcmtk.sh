#!/bin/bash
if [ "$1" == "" ] ; then
  echo "%%%%%% ERROR: You have to put as first argument the directory where you want DCMTK for GAMOS to be installed"
  exit 1
else
  export GAMOSREP=$1
  export LINUX_SYSTEM=uncompiled
fi

export GAMOS_VER=5.2.0

export DCMTK_VER=58b8dde

mkdir -p $GAMOSREP/external/dcmtk

MYPWD=$PWD
cd $GAMOSREP/external/dcmtk
echo @@@@@@@@@@@@ PWD $PWD

export GAMOSWEB=http://fismed.ciemat.es/GAMOS/download/GAMOS.$GAMOS_VER/$LINUX_SYSTEM

is_curl=`which curl |wc -w`
is_wget=`which wget |wc -w`

if [ $is_curl = 1 ]; then
  echo "curl found, downloading sources ..."
  curl -v --connect-timeout 30 -f -L -O $GAMOSWEB/dcmtk-$DCMTK_VER.source.tar.gz
elif [ $is_wget = 1 ]; then
  echo "wget found, downloading sources ..."
  wget -N $GAMOSWEB/dcmtk-$DCMTK_VER.source.tar.gz
else
  echo "!!! You need curl or wget installed in your system to download GAMOS source files, so please install one of these first"
  echo 1 > $GAMOSREP/exit.code
  exit 1
fi

echo Installing DCMTK version $DCMTK_VER...
mkdir source.code
cd source.code
tar zxf ../dcmtk-$DCMTK_VER.source.tar.gz
cd  dcmtk-$DCMTK_VER
echo @@@@@@@@@@@@ PWD $PWD $GAMOSREP/external/dcmtk/dcmtk-$DCMTK_VER

echo configure $GAMOSREP/external/dcmtk/dcmtk-$DCMTK_VER
./configure --prefix=$GAMOSREP/external/dcmtk/dcmtk-$DCMTK_VER --without-libxml

ls -l config/Makefile.def.shared 
awk -v GAMOSREP=$GAMOSREP -v DCMTK_VER=$DCMTK_VER '{
  if($1=="prefix") {printf("%s %s %s \n",$1, $2, GAMOSREP"/external/dcmtk/dcmtk-"DCMTK_VER) }      
  else { print $0 }
}' "config/Makefile.def.shared" > "config/Makefile.def"
sed -i s/"dcmtk-58b8dde "/"dcmtk-58b8dde"/g config/Makefile.def

echo @@@ make
make
echo @@@ make install-lib
make install-lib
echo @@@ make install
make install

cd $MYPWD

#rm ../../dcmtk-$DCMTK_VER.source.tar.gz


