#!/bin/bash
## First argument is the directory where you want to install GAMOS

if [ "$1" == "" ] ; then
  echo "%%%%%% ERROR: You have to put as first argument the directory where you want GAMOS to be installed"
  exit 1
else
  export GAMOSREP=$1
  if [ `uname` == "Linux" ] ; then
      export LINUX_SYSTEM=Linux-g++
  elif [ `uname` == "Darwin" ] ;  then
      system_ver=`uname -r | sed 's/\([0-9]*\).[0-9]*.[0-9]*/\1/'`
      if [ $system_ver == "16" ] ; then
	  export LINUX_SYSTEM=Darwin16-g++
      else 
	  export LINUX_SYSTEM=Darwin-g++
      fi
  fi
  
fi

export GAMOSFILES=$PWD

#### PACKAGE VERSIONS (this are set automatically for each GAMOS release)
export GAMOS_VER=5.2.0

export GEANT4_VER=10.03.p03.gamos

export ROOT_VER=5.34.36
