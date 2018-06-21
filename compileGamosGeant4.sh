#!/bin/bash
export MYPWD=$PWD

source ./installGamosBaseDefs.sh $1

echo Installing GEANT4 VERSION $GEANT4_VER 
cd $GAMOSREP/external/geant4/geant4.$GEANT4_VER/

# sed -i has different syntax in linux and MacOS
sed s:MY_GAMOS_DIR:"$GAMOSREP":g geant4conf.sh > ttt
mv ttt geant4conf.sh

sed s:MY_GAMOS_DIR:"$GAMOSREP":g geant4conf.csh > ttt
mv ttt geant4conf.csh  

source ./geant4conf.sh

cd source
make -j2

cd $GAMOSREP

cd $MYPWD
