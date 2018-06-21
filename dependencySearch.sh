#!/bin/bash

set -e

GEANT4_LOCAL_REP=$GAMOSREP/external/geant4/geant4.$GEANT4_VER
#echo $GEANT4_LOCAL_REP

echo "##### X11 and OpenGL #####" >> $GEANT4_LOCAL_REP/geant4conf.sh
echo "##### X11 and OpenGL #####" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
echo "##### X11 and OpenGL #####" >> $GEANT4_LOCAL_REP/geant4conf.csh
echo "##### X11 and OpenGL #####" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh


#****************************************
# Define system dependent variables     *
#****************************************
if [ `uname` == "Linux" ] ; then
  export SHEXT=so
elif [ `uname` == "Darwin" ] ; then
  export SHEXT=dylib
else
  echo "!!! ERROR: Unknown system, only Linux and Darwin supported"
  echo 2 > $GAMOSREP/exit.code
  return
fi

#************************************
### Locate g++ compiler location  ###
#************************************
#compiler_dir=`find /usr/bin /usr/local/bin -name g++ 2>/dev/null|xargs echo`
compiler=`which g++ |wc -w`

if [ $compiler = 0 ]; then
    echo "Your system doesn't have g++ compiler, you have to install it first."
    echo 2 > $GAMOSREP/exit.code
    return
else
    echo "@@ g++ compiler found at: " `which g++` `g++ -v`
fi

#*************************************
###  Identify system arquitecture ###
#************************************
arquitecture=`uname -p | grep 64 | wc -w`
if [ "$arquitecture" = "1" ] ; then
    LIB_DIR=lib64
else
    LIB_DIR=lib
fi
    fpl="/usr/X11R6/$LIB_DIR /usr/local/$LIB_DIR /usr/$LIB_DIR /usr/lib/x86_64-linux-gnu /opt/X11 /opt/local/lib"
    fpi="/usr/X11R6/include /usr/local/include /usr/include /opt/X11/include /usr/lib/x86_64-linux-gnu /opt/local/include"
    for dire in $fpl ; do
      if [ -d $dire ] ; then
        find_pathl="$find_pathl $dire"
      fi
    done
    for dire in $fpi ; do
      if [ -d $dire ] ; then
        find_pathi="$find_pathi $dire"
      fi
    done

#***********************************
###  Locate X11 library  ###
#***********************************
X11l_dirs=`find $find_pathl -name libX11.${SHEXT} 2>/dev/null|xargs echo`
X11i_dirs=`find $find_pathi | grep X11/Xdefs.h 2>/dev/null|xargs echo`
Xfti_dirs=`find $find_pathi | grep Xft/Xft.h 2>/dev/null|xargs echo`
Xmui_dirs=`find $find_pathi | grep Xmu/Xmu.h 2>/dev/null|xargs echo`
Xexti_dirs=`find $find_pathi | grep Xext.h 2>/dev/null|xargs echo`

# try lib if not found int lib64
if  [ "X$X11l_dirs" = "X" ] ; then
 LIB_DIR=lib
 find_pathl="/usr/X11R6/$LIB_DIR /usr/local/$LIB_DIR /usr/$LIB_DIR /usr/lib/x86_64-linux-gnu"
 X11l_dirs=`find $find_pathl -name libX11.${SHEXT} 2>/dev/null|xargs echo`
fi

# check for other libraries associated to X11
if  [ "X$X11l_dirs" != "X" ] ; then
    echo "@@ libX11.so library found at: " $X11l_dirs
    X11l_dirs=`find $find_pathl -name libICE.${SHEXT} 2>/dev/null|xargs echo`
fi
if  [ "X$X11l_dirs" != "X" ] ; then
    echo "@@ libICE.so library found at: " $X11l_dirs
    X11l_dirs=`find $find_pathl -name libSM.${SHEXT} 2>/dev/null|xargs echo`
fi
if  [ "X$X11l_dirs" != "X" ] ; then
    echo "@@ libSM.so library found at: " $X11l_dirs
    X11l_dirs=`find $find_pathl -name libXpm.${SHEXT} 2>/dev/null|xargs echo`
fi
if  [ "X$X11l_dirs" != "X" ] ; then
    echo "@@ libXpm.so library found at: " $X11l_dirs
    X11l_dirs=`find $find_pathl -name libXext.${SHEXT} 2>/dev/null|xargs echo`
fi
if  [ "X$X11l_dirs" != "X" ] ; then
    echo "@@ libXext.so library found at: " $X11l_dirs
    X11l_dirs=`find $find_pathl -name libXi.${SHEXT} 2>/dev/null|xargs echo`
fi
if  [ "X$X11l_dirs" != "X" ] ; then
    echo "@@ libXi.so library found at: " $X11l_dirs
fi 

###  If X11 found continue ###
#if [ "X$X11l_dirs" = "X" ] && [ "X$X11i_dirs" != "X" ] && [ "X$Xfti_dirs" != "X" ] && [ "X$Xmui_dirs" != "X" ] ; then
if [ "X$X11l_dirs" != "X" ] && [ "X$X11i_dirs" != "X" ] && [ "X$Xfti_dirs" != "X" ] && [ "X$Xmui_dirs" != "X" ] ; then

    g4X11l_base_dir_found=`echo $X11l_dirs|cut -d" " -f1`

# That's right: should be twice! (e.g./usr/lib/libX11.${SHEXT} -> /usr)
    g4X11l_base_dir_found=`dirname $g4X11l_base_dir_found`
    g4X11l_base_dir_found=`dirname $g4X11l_base_dir_found`
    
    echo "export X11LIB_HOMEDIR=$g4X11l_base_dir_found/$LIB_DIR" >> $GEANT4_LOCAL_REP/geant4conf.sh
    echo "export X11LIB_HOMEDIR=$g4X11l_base_dir_found/$LIB_DIR" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
    echo "setenv X11LIB_HOMEDIR $g4X11l_base_dir_found/$LIB_DIR" >> $GEANT4_LOCAL_REP/geant4conf.csh
    echo "setenv X11LIB_HOMEDIR $g4X11l_base_dir_found/$LIB_DIR" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
    
#    echo "X11 libraries found at: $g4X11l_base_dir_found"
    
#****************************************
### Locate X11 include files ###
#****************************************
    
#    if  [ "X$X11i_dirs" = "X" ] ; then
#	X11i_dirs=`locate Xdefs.h`
#    fi
    
###  If X11 found continue ###
    if [ "X$X11i_dirs" != "X" ] ; then
	g4X11i_base_dir_found=`echo $X11i_dirs|cut -d" " -f1`
	
         # That's right: should be twice! (e.g./usr/include/X11/Xdefs.h  -> /usr/include/X11)
	g4X11i_base_dir_found=`dirname $g4X11i_base_dir_found`
	
	echo "export X11INC_HOMEDIR=$g4X11i_base_dir_found" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "export X11INC_HOMEDIR=$g4X11i_base_dir_found" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "setenv X11INC_HOMEDIR $g4X11i_base_dir_found" >> $GEANT4_LOCAL_REP/geant4conf.csh
	echo "setenv X11INC_HOMEDIR $g4X11i_base_dir_found" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	
	echo "export X11INC_HOME_EXT=$g4X11i_base_dir_found/extensions" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "export X11INC_HOME_EXT=$g4X11i_base_dir_found/extensions" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "setenv X11INC_HOME_EXT $g4X11i_base_dir_found/extensions" >> $GEANT4_LOCAL_REP/geant4conf.csh
	echo "setenv X11INC_HOME_EXT $g4X11i_base_dir_found/extensions" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	
	echo "@@ X11 include directory found at: $g4X11i_base_dir_found"

ln -s /usr/lib/x86_64-linux-gnu/libX11.so /usr/lib/libX11.so
ln -s /usr/lib/x86_64-linux-gnu/libXft.so /usr/lib/libXft.so
ln -s /usr/lib/x86_64-linux-gnu/libXext.so /usr/lib/libXext.so
ln -s /usr/lib/x86_64-linux-gnu/libXpm.so /usr/lib/libXpm.so
ln -s /usr/lib/x86_64-linux-gnu/libXmu.so /usr/lib/libXmu.so
ln -s /usr/lib/x86_64-linux-gnu/libXi.so /usr/lib/libXi.so
ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib/libfreetype.so
ln -s /usr/include/freetype2 /usr/include/freetype
ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so
ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so
ln -s /usr/lib/x86_64-linux-gnu/libtiff.so /usr/lib/libtiff.so
ln -s /usr/lib/x86_64-linux-gnu/libAfterImage.so /usr/lib/libAfterImage.so

#*************************************
### Locate OpenGL library ###
#*************************************
	ogll_dirs=`find $find_pathl -name libGLU.${SHEXT} 2>/dev/null|xargs echo`
	ogli_dirs=`find $find_pathi -name glu.h 2>/dev/null|xargs echo`

	if  [ "X$ogll_dirs" = "X" ] ; then
	   LIB_DIR=lib
	   find_pathl="/usr/X11R6/$LIB_DIR /usr/local/$LIB_DIR /usr/$LIB_DIR /usr/lib/x86_64-linux-gnu"
           ogll_dirs=`find $find_pathl -name libGLU.${SHEXT}  2>/dev/null|xargs echo`
	fi

echo OGLL_DIRS $ogll_dirs find $find_pathl -name libGLU.${SHEXT} 
echo OGLI_DIRS $ogli_dirs find $find_pathi -name glu.h 
        find $find_pathi -name glu.h 
	if [ "X$ogll_dirs" != "X" ] && [ "X$ogli_dirs" != "X" ] ; then
	    g4ogl_base_dir_found=`echo $ogll_dirs|cut -d" " -f1`
	    echo G4OGL_BASE_DIR_FOUND $g4ogl_base_dir_found
                 # That's right: should be twice! (e.g./usr/local/lib/libGLU.${SHEXT} -> /usr/local)
	    g4ogl_base_dir_found=`dirname $g4ogl_base_dir_found`
	    echo G4OGL_BASE_DIR_FOUND $g4ogl_base_dir_found
#	    g4ogl_base_dir_found=`echo $g4ogl_base_dir_found | sed s:/lib::g`
#	    echo G4OGL_BASE_DIR_FOUND $g4ogl_base_dir_found

	    if [ "`ls ${g4ogl_base_dir_found}/libGLU.${SHEXT}|tail -1`" != "" ]; then
                echo OGLHOME $g4ogl_base_dir_found
	             #  export OGLHOME ${OGLHOME}/`ls ${OGLHOME}|tail -1` # select latest version
		echo "You are set to compile with OpenGL library:"
		echo "OpenGL home directory: $g4ogl_base_dir_found"
		
		echo "export OGLHOME=$g4ogl_base_dir_found" >> $GEANT4_LOCAL_REP/geant4conf.sh
		echo "export OGLHOME=$g4ogl_base_dir_found" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
		echo "setenv OGLHOME $g4ogl_base_dir_found" >> $GEANT4_LOCAL_REP/geant4conf.csh
		echo "setenv OGLHOME $g4ogl_base_dir_found" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
		
		echo "export G4VIS_BUILD_OPENGLX_DRIVER=1" >> $GEANT4_LOCAL_REP/geant4conf.sh
		echo "export G4VIS_BUILD_OPENGLX_DRIVER=1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
		echo "setenv G4VIS_BUILD_OPENGLX_DRIVER 1" >> $GEANT4_LOCAL_REP/geant4conf.csh
		echo "setenv G4VIS_BUILD_OPENGLX_DRIVER 1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
		
		echo "export G4VIS_USE_OPENGLX=1" >> $GEANT4_LOCAL_REP/geant4conf.sh
		echo "export G4VIS_USE_OPENGLX=1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
		echo "setenv G4VIS_USE_OPENGLX 1" >> $GEANT4_LOCAL_REP/geant4conf.csh
		echo "setenv G4VIS_USE_OPENGLX 1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
		
		echo "export G4VIS_BUILD_OPENGL_DRIVER=1" >> $GEANT4_LOCAL_REP/geant4conf.sh
		echo "export G4VIS_BUILD_OPENGL_DRIVER=1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
		echo "setenv G4VIS_BUILD_OPENGL_DRIVER 1" >> $GEANT4_LOCAL_REP/geant4conf.csh
		echo "setenv G4VIS_BUILD_OPENGL_DRIVER 1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
		
		echo "export G4VIS_USE_OPENGL=1" >> $GEANT4_LOCAL_REP/geant4conf.sh
		echo "export G4VIS_USE_OPENGL=1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
		echo "setenv G4VIS_USE_OPENGL 1" >> $GEANT4_LOCAL_REP/geant4conf.csh
		echo "setenv G4VIS_USE_OPENGL 1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
		
		echo export OGLLIBS=\"-L${g4ogl_base_dir_found} -lGLU -lGL\" >> $GEANT4_LOCAL_REP/geant4conf.sh
		echo export OGLLIBS=\"-L${g4ogl_base_dir_found} -lGLU -lGL\" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
		echo setenv OGLLIBS \"-L${g4ogl_base_dir_found} -lGLU -lGL\" >> $GEANT4_LOCAL_REP/geant4conf.csh
		echo setenv OGLLIBS \"-L${g4ogl_base_dir_found} -lGLU -lGL\" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	    fi
	else 
	   
	    echo "opengl not found"	     
	fi
    fi
    
fi
# echo "!!! No X11 libraries version found" $X11l_dirs $X11i_dirs "  Check for libraries libX11.${SHEXT} libICE.${SHEXT} libSM.${SHEXT} libXpm.${SHEXT} libXext.${SHEXT} libXi.${SHEXT} "
if [ "X$X11l_dirs" = "X" ] || [ "X$X11i_dirs" = "X" ] ; then    
    echo "!!! No X11 libraries version found" $X11l_dirs $X11i_dirs "  Check for libraries libX11.${SHEXT} libICE.${SHEXT} libSM.${SHEXT} libXpm.${SHEXT} libXext.${SHEXT} libXi.${SHEXT} "
fi

if  [ "X$Xfti_dirs" = "X" ] ; then    
    echo "!!! No Xft libraries version found"
fi
if  [ "X$Xmui_dirs" = "X" ] ; then    
    echo "!!! No Xmu libraries version found"
fi

echo 0 > $GAMOSREP/exit.code

if [ "X$ogll_dirs" = "X" ] || [ "X$ogli_dirs" = "X" ] ; then
    
    echo "!!! No OpenGL libraries version found"
    
    echo "!!! GAMOS will be installed without OpenGL Visualisation. Do you want to continue (yes/no): "
    
    read ansOGL
    cend="no"
    while [ "$cend" = "no" ]; do
	if [ "$ansOGL" = "no" ]; then
	    cend="yes"
	elif [ "$ansOGL" = "yes" ]; then
	    cend="yes"
	elif [ "$ansOGL" = "" ]; then
	    cend="yes"
	    ansOGL="yes"
	else 
	    echo "Please repeat your answer, it should be yes or no: "    
	    read ansOGL
	fi
    done

    if [ "$ansOGL" = "yes" ]; then

	echo "unset G4VIS_BUILD_OPENGL_DRIVER" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "unset G4VIS_BUILD_OPENGL_DRIVER" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "unsetenv G4VIS_BUILD_OPENGL_DRIVER" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	echo "unsetenv G4VIS_BUILD_OPENGL_DRIVER" >> $GEANT4_LOCAL_REP/geant4conf.csh
	
	echo "unset G4VIS_USE_OPENGL" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "unset G4VIS_USE_OPENGL" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "unsetenv G4VIS_USE_OPENGL" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	echo "unsetenv G4VIS_USE_OPENGL" >> $GEANT4_LOCAL_REP/geant4conf.csh
	
	echo "unset OGLHOME" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "unset OGLHOME" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "unsetenv OGLHOME" >> $GEANT4_LOCAL_REP/geant4conf.csh
	echo "unsetenv OGLHOME" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	
	echo "unset OGLLIBS" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "unset OGLLIBS" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "unsetenv OGLLIBS" >> $GEANT4_LOCAL_REP/geant4conf.csh
	echo "unsetenv OGLLIBS" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh  

    else 
	echo 2 > $GAMOSREP/exit.code
	return
    fi
fi
	
if [ "X$X11l_dirs" = "X" ] || [ "X$X11i_dirs" = "X" ] || [ "X$Xfti_dirs" = "X" ] || [ "X$Xmui_dirs" = "X" ]  || [ "X$Xexti_dirs" = "X" ] ; then
    
    echo "!!! No X11, Xft, Xmu or Xext libraries version found"
    
    echo "!!! GAMOS will be installed without OpenGLX Visualisation and without ROOT. Do you want to continue (yes/no): "
    
    read ansX
    cend="no"
    while [ "$cend" = "no" ]; do
	if [ "$ansX" = "no" ]; then
	    cend="yes"
	elif [ "$ansX" = "yes" ]; then
	    cend="yes"
	elif [ "$ansX" = "" ]; then
	    cend="yes"
	    ansX="yes"
	else 
	    echo "Please repeat your answer, it should be yes or no: " 
	    read ansX
	fi
    done
    
    if [ "$ansX" = "yes" ]; then
	
#	echo "export GAMOS_NO_ROOT=1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/confgamos.sh
#	echo "setenv GAMOS_NO_ROOT 1" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/confgamos.csh
	
#	export GAMOS_NO_ROOT=1
	
	echo "unset G4VIS_BUILD_OPENGLX_DRIVER" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "unset G4VIS_BUILD_OPENGLX_DRIVER" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "unsetenv G4VIS_BUILD_OPENGLX_DRIVER" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	echo "unsetenv G4VIS_BUILD_OPENGLX_DRIVER" >> $GEANT4_LOCAL_REP/geant4conf.csh
	
	echo "unset G4VIS_USE_OPENGLX" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.sh
	echo "unset G4VIS_USE_OPENGLX" >> $GEANT4_LOCAL_REP/geant4conf.sh
	echo "unsetenv G4VIS_USE_OPENGLX" >> $GEANT4_LOCAL_REP/geant4conf.csh
	echo "unsetenv G4VIS_USE_OPENGLX" >> $GAMOSREP/GAMOS.$GAMOS_VER/config/gamosvis.csh
	
	echo 0 > $GAMOSREP/exit.code
    else 
	echo 2 > $GAMOSREP/exit.code
	return
    fi
fi

