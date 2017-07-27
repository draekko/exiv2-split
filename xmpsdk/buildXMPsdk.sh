#!/usr/bin/env bash

##
# buildXMPsdk.sh
##

let CUSTOMSDK=0
SDK201412=XMP-Toolkit-SDK-CC201412
SDK201607=XMP-Toolkit-SDK-CC201607
CURRENTSDK=$SDK201607
SDKPATH=adobe_xmp_sdk/$CURRENTSDK
let SDKBITS=64
SDKRELEASE="Release"

for i in "$@"
do
case $i in
    --sdk201412)
    CURRENTSDK=$SDK201412
    SDKPATH=adobe_xmp_sdk/$CURRENTSDK
    shift # past argument=value
    ;;
    --sdk201607)
    CURRENTSDK=$SDK201607
    SDKPATH=adobe_xmp_sdk/$CURRENTSDK
    shift # past argument=value
    ;;
    -c=*|--customsdkpath=*)
    SDKPATH="${i#*=}"
    let CUSTOMSDK=1
    shift # past argument=value
    ;;
    --sdk32)
    let SDKBITS=32
    shift # past argument=value
    ;;
    --sdk64)
    let SDKBITS=64
    shift # past argument=value
    ;;
    --sdkdebug)
    SDKRELEASE="Debug"
    shift # past argument=value
    ;;
    *)
      echo ""
      echo "Options:"
      echo "    --sdk201412              Use the convenience repository version"
      echo "    --sdk201607              Use the convenience repository version"
      echo "    --customsdkpath=/path    Specify a custom XMP SDK path"
      echo "    --sdkdebug               Specify a debug build"
      echo "    --sdk32                  Specify a 32bit build"
      echo "    --sdk64                  Specify a 64bit build"
      echo ""
      echo "Examples:"
      echo "    buildXMPsdk.sh --sdk201412 --sdk32"
      echo "    buildXMPsdk.sh --sdk64 --customsdkpath=/opt/Build/XMP-Toolkit-SDK-CC201607"
      echo ""
      exit 1
      # unknown option
    ;;
esac
done

echo ""
echo "Build using:"
echo "   Architecture  ................. $SDKBITS"
echo "   XMP SDK Path  ................. $SDKPATH"
echo ""
uname=$(uname -s)
case "$uname" in
    Darwin|Linux|GNU/Linux|Cygwin) ;;
    *)  echo "*** unsupported platform $uname ***"
        exit 1
    ;;
esac

##
# Download the code
if [ ! -e adobe_xmp_sdk ]; then (
    git clone https://github.com/Exiv2/adobe_xmp_sdk.git
    cd adobe_xmp_sdk
    git checkout $CURRENTSDK
) fi

##
# Using custom XMP SDK so copy third-party code into SDK
if [ $CUSTOMSDK -eq 1 ]; then
(
    find third-party -type d -maxdepth 1 -exec cp -R '{}' adobe_xmp_sdk/XMP-Toolkit-SDK-CC201607/third-party ';'
)
fi

##
# generate Makefile and build
(   cd $SDKPATH/build
    ##
    # Tweak the code (depends on platform)
    case "$uname" in
        GNU/Linux|Linux)
            # Uncomment if using the stock Adobe XMP Toolkit SDK to modify ProductConfig.cmake (don't link libssp.a)
            if [ $CUSTOMSDK -eq 1 ]; then
                f=ProductConfig.cmake
                if [ -e $f.orig ]; then mv $f.orig $f ; fi ; cp $f $f.orig
                sed -E -e 's? \$\{XMP_GCC_LIBPATH\}/libssp.a??g' $f.orig > $f
            fi
            ./cmake.command $SDKBITS Static $SDKRELEASE ToolchainGCC.cmake Clean
            if [ $SDKBITS -eq 64 ]; then
                make -C ./gcc/static/i80386linux_64/Release
            else
                make -C ./gcc/static/i80386linux/Release
            fi

        ;;

        Cygwin)
            f=../source/Host_IO-POSIX.cpp
            if [ -e $f.orig ]; then mv $f.orig $f ; fi ; cp $f $f.orig
            sed -E -e $'s?// Writeable?// Writeable~#include <windows.h>~#ifndef PATH_MAX~#define PATH_MAX 512~#endif?' $f.orig | tr "~" "\n" > $f

            cmake . -G "Unix Makefiles"              \
              -DXMP_ENABLE_SECURE_SETTINGS=OFF \
              -DXMP_BUILD_STATIC=1             \
              -DCMAKE_CL_64=ON                 \
              -DCMAKE_BUILD_TYPE=Release
        ;;

        Darwin)
#           Original line was as below in the Generate script from the XMP SDK
#           ./cmake.command $SDKBITS Static WarningAsError ToolchainLLVM.cmake
            ./cmake.command $SDKBITS Static $SDKRELEASE ToolchainLLVM.cmake
            if [ $SDKBITS -eq 64 ]; then
                make -C ./gcc/static/i80386linux_64/Release
            else
                make -C ./gcc/static/i80386linux/Release
            fi
        ;;
    esac
    make
)

##
# copy headers and built libraries
(
    rm -rf include
    cp -R  $SDKPATH/public/include include

    # report archives we can see
    cd $SDKPATH
    find public -name "*.a" -o -name "*.ar" | xargs ls -alt
    cd ../..

    # move the library/archives into xmpsdk
    case "$uname" in
      Cygwin99|GNU/Linux|Linux)
          find $SDKPATH/public -name "*.ar" -exec cp {} . ';'
          ./ren-lnx.sh
      ;;

      Darwin)
        find $SDKPATH/public -name "*.a" -exec cp {} . ';'
        ./ren-mac.sh
      ;;
    esac
    ls -alt *.a

    if [ 1 == 2 ]; then
    # combine libraries into libxmpsdk.a
        mkdir  foo
        mv *.a foo
        cd     foo
        for i in *.a; do ar -x $i ; rm -rf $i ; done
        ar -cq libxmpsdk.a *.o
        mv     libxmpsdk.a  ..
        cd ..
        rm -rf foo
        ls -alt *.a
    fi
)

# That's all Folks!
##
