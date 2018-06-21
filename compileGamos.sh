#!/bin/bash

export MYPWD=$PWD

source ./installGamosBaseDefs.sh $1

cd $GAMOSREP/GAMOS.$GAMOS_VER/config

sed s:MY_GAMOS_DIR:"$GAMOSREP":g confgamos.csh > ttt
mv ttt confgamos.csh
sed s:MY_LINUX_SYSTEM:"$LINUX_SYSTEM":g confgamos.csh > ttt
mv ttt confgamos.csh 
sed s:MY_G4INSTALL:"$GAMOSREP/external/geant4/geant4.$GEANT4_VER":g confgamos.csh > ttt
mv ttt confgamos.csh 
if [ "$LINUX_SYSTEM" != "Darwin16-g++" ] ; then
  sed s:ROOT_VER:"$ROOT_VER":g confgamos.csh > ttt
else
  sed s:"\${GAMOSEXTERNAL}/root/ROOT_VER/root":"/opt/local/libexec/root5":g confgamos.csh > ttt
  mv ttt confgamos.csh
  sed s:"\${GAMOSEXTERNAL}/dcmtk/dcmtk-58b8dde":"/opt/local/":g confgamos.csh > ttt
  cp root.Darwin16.gmk root.gmk
fi
mv ttt confgamos.csh
sed s:GEANT4_VER:"$GEANT4_VER":g confgamos.csh > ttt
mv ttt confgamos.csh 

sed s:MY_GAMOS_DIR:"$GAMOSREP":g confgamos.sh > ttt
mv ttt confgamos.sh
sed s:MY_LINUX_SYSTEM:"$LINUX_SYSTEM":g confgamos.sh > ttt
mv ttt confgamos.sh 
sed s:MY_G4INSTALL:"$GAMOSREP/external/geant4/geant4.$GEANT4_VER":g confgamos.sh > ttt
mv ttt confgamos.sh 
if [ "$LINUX_SYSTEM" != "Darwin16-g++" ] ; then
  sed s:ROOT_VER:"$ROOT_VER":g confgamos.sh > ttt
else 
  sed s:"\${GAMOSEXTERNAL}/root/ROOT_VER/root":"/opt/local/libexec/root5":g confgamos.sh > ttt 
  mv ttt confgamos.sh
  sed s:"\${GAMOSEXTERNAL}/dcmtk/dcmtk-58b8dde":"/opt/local/":g confgamos.sh > ttt
fi

mv ttt confgamos.sh 
sed s:GEANT4_VER:"$GEANT4_VER":g confgamos.sh > ttt
mv ttt confgamos.sh


source ./confgamos.sh

cd ../source

make -j2
make 
cd ../analysis
make -j3
make

cd $MYPWD

