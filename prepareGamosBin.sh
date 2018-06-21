# sh prepareGamosBin.sh $HOME/gamos MacOSX12
source ./installGamosBaseDefs.sh $1

cd $GAMOSREP
echo $1 >  GAMOS.$GAMOS_VER/gamosrep.tmp
rm -r GAMOS.$GAMOS_VER/tmp 
rm -r external/geant4/geant4.$GEANT4_VER/tmp 
rm external/root/$ROOT_VER/root/*/*/src/*.o
rm external/root/$ROOT_VER/root/*/*/src/*.d
tar zcvf GAMOS.$GAMOS_VER.$2.tgz GAMOS.$GAMOS_VER
tar zcvf geant4.$GEANT4_VER.$2.tar.gz external/geant4/geant4.$GEANT4_VER/
#tar zcvf geant4.$GEANT4_VER.data.$2.tar.gz external/geant4/data
tar zcvf root_v$ROOT_VER.$2.tar.gz external/root/$ROOT_VER
