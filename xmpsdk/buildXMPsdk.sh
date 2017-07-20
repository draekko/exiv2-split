#!/bin/bash

##
# buildXMPsdk.sh
# TODO:
#     1) Command-line parser for options such as:
#	 version of xmpsdk (2014, 2016)
#	 build options     (64/32 static/dynamic debug/release)
#        help
#     2) Cygwin support
#     3) Write buildXMPsdk.cmd (for MSVC)
##

uname=$(uname -o)
supported=0
if [ "$uname" != "Darwin"     ]; then supported=1 ; fi
if [ "$uname" != "GNU/Linux"  ]; then supported=1 ; fi
# if [ "$uname" != "Cygwin"     ]; then supported=1 ; fi

if [ "$supported" == 0 ]; then
    echo "*** unsupported platform $uname ***"
    exit 1
fi

##
# Download the code from Adobe
if [ ! -e Adobe ]; then (
    mkdir Adobe
    cd    Adobe
    curl -O http://download.macromedia.com/pub/developer/xmp/sdk/XMP-Toolkit-SDK-CC201607.zip
    unzip XMP-Toolkit-SDK-CC201607.zip
) fi

##
# copy third-party code into SDK
(
    find third-party -type d -maxdepth 1 -exec cp -R '{}' Adobe/XMP-Toolkit-SDK-CC201607/third-party ';'
)

##
# generate Makefile and build
(   cd Adobe/XMP-Toolkit-SDK-CC201607/build
    ##
    # modify ProductConfig.cmake (don't link libssp.a)
    f=ProductConfig.cmake
    if [ -e $f.orig ]; then
        mv $f.orig $f
    fi
    cp $f $f.orig
    sed -E -e 's? \$\{XMP_GCC_LIBPATH\}/libssp.a??g' $f.orig > $f

    # copy resources
    if [ "$uname" == "GNU/Linux" ]; then for f in XMPFiles XMPCore; do
       cp ../$f/resource/linux/* ../$f/resource
    done ; fi
    
    cmake . -G "Unix Makefiles" -DXMP_ENABLE_SECURE_SETTINGS=OFF -DXMP_BUILD_STATIC=1 -DCMAKE_CL_64=ON -DCMAKE_BUILD_TYPE=Release
    
    make
)
##
# copy built libraries and headers to XMPsdk
(   cd Adobe/XMP-Toolkit-SDK-CC201607
    find public -name "*.a" -o -name "*.ar" | xargs ls -alt
    cd ../..
    
    find Adobe/XMP-Toolkit-SDK-CC201607/public -name "*.a" -o -name "*.ar" -exec cp {} . ';'
    if [ "$uname" == "GNU/Linux" ]; then ./ren-lnx.sh ;fi
    if [ "$uname" == "Darwin"    ]; then ./ren-mac.sh ;fi
    ls -alt *.a
)

# That's all Folks!
##
