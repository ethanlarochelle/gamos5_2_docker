#!/bin/sh
portCmd=`which port`
if [ X$portCmd == "X" ] ; then
 echo !!! macports NOT FOUND, please install it first
 echo 2 > $GAMOSREP/exit.code
 exit
fi
xcodeCmd=`which xcodebuild`
if [ X$xcodeCmd == "X" ] ; then
 echo !!! Xcode NOT FOUND, please install it first
 echo 2 > $GAMOSREP/exit.code
 exit
fi

sudo port install root5
sudo port install dcmtk
sudo port search libGLU
sudo xcodebuild -license
sudo port install openmotif
sudo port install xorg-libXt +flat_namespace
sudo port install glw
sudo port install xz
