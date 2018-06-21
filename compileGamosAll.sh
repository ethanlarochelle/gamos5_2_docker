#!/bin/bash

source ./installGamosBaseDefs.sh $1

source ./compileGamosRoot.sh $1 
source ./compileGamosGeant4.sh $1
source ./compileGamos.sh $1 
#source ./compileGamos.sh $1

