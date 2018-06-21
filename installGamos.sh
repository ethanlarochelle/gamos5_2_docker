#!/bin/bash

source ./installGamosBaseDefs.sh $1

system=`uname`
if [ $system == "Linux" ] ; then
  source ./installGamosDcmtk.sh $1 2>&1 | tee -a $GAMOSREP/install.log
elif [ $system == "Darwin" ] ; then
  system_ver=`uname -r | sed 's/\([0-9]*\).[0-9]*.[0-9]*/\1/'`
  if [ $system_ver != "16" ] ; then
    source ./installGamosDcmtk.sh $1 2>&1 | tee -a $GAMOSREP/install.log
  fi
fi

source ./installGamosOpenjpeg.sh $1 2>&1 | tee -a $GAMOSREP/install.log

mkdir $GAMOSREP

source ./getGamosFiles.sh $1 $2 2>&1 | tee -a $GAMOSREP/install.log


EXIT_CODE=`tail -1 $GAMOSREP/exit.code`

if [ "$EXIT_CODE" = "1" ]; then
echo !! EXITING: PROBLEM IN GETTING FILES
exit 
fi
if [ "$EXIT_CODE" = "2" ]; then
echo !! EXITING: PROBLEM SEARCHING FOR DEPENDENCIES
exit 
fi

source ./compileGamosAll.sh $1 2>&1 | tee -a $GAMOSREP/install.log 

cd $GAMOSREP

rm GAMOS.$GAMOS_VER.tgz
rm geant4.$GEANT4_VER.tar.gz
rm geant4.$GEANT4_VER.data.tar.gz
rm root_v$ROOT_VER.source.tar.gz

grep " error" $GAMOSREP/install.log >  $GAMOSREP/install_error.log
nerr=`wc -l  $GAMOSREP/install_error.log | awk '{print $1}'`
if [ "$nerr" != "0" ]; then
  echo "!!! GAMOS INSTALLATION FAILED, SEE ERRORS at :" $GAMOSREP/install_error.log
  cat  $GAMOSREP/install_error.log
  echo " !!! IT MAY BE ONLY WARNINGS, OR ERRORS THAT ONLY AFFECT SOME UTILITIES BUT NOT THE MAIN gamos PROGRAM. PLEASE CHECK"
else 
  echo "!!! GAMOS INSTALLATION IS OK !!!"
fi

