#!/bin/bash

source ./installGamosBaseDefs.sh $1 

rm -r $GAMOSREP/external/geant4/geant4.$GEANT4_VER/lib
rm -r $GAMOSREP/external/geant4/geant4.$GEANT4_VER/tmp
rm -r $GAMOSREP/external/geant4/geant4.$GEANT4_VER/bin
cd $GAMOSREP/GAMOS.$GAMOS_VER/config
awk -v GAMOSREP=$GAMOSREP '{
  if(substr($2,0,9)=="GAMOSDIR=") {printf("%s %s \n",$1, substr($2,0,9)GAMOSREP) }
  else { print $0 }
}' confgamos.sh > confgamos.sh-
mv confgamos.sh- confgamos.sh

awk -v GAMOSREP=$GAMOSREP '{
  if($2=="GAMOSDIR") {printf("%s %s %s \n",$1, $2, GAMOSREP) }
  else { print $0 }
}' confgamos.csh > confgamos.csh-
mv confgamos.csh- confgamos.csh

cd -
source ./compileGamosAll.sh $1 2>&1 | tee -a $GAMOSREP/install.log 

grep " error" $GAMOSREP/install.log >  $GAMOSREP/install_error.log
nerr=`wc -l  $GAMOSREP/install_error.log | awk '{print $1}'`
if [ "$nerr" != "0" ]; then
  echo "!!! GAMOS INSTALLATION FAILED, SEE ERRORS at :" $GAMOSREP/install_error.log
  cat  $GAMOSREP/install_error.log
else 
  echo "!!! GAMOS INSTALLATION IS OK !!!"
fi
