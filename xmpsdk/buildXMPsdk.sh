#!/bin/bash

##
# buildXMPsdk.sh
# Work in Progress.  Incomplete.  Mac Only at the moment.
# TODO:
#	Command-line parser for options such as:
#		version of xmpsdk (2014, 2016)
#		build options     (64/32 static/dynamic debug/release)
#       help
#   Cygwin and Linux  buildXMPsdk.bat (for MSVC)
##

uname=$(uname)
if [ "$uname" != "Darwin" ]; then
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
	ditto third-party/expat/ Adobe/XMP-Toolkit-SDK-CC201607/third-party/expat
	ditto third-party/zlib/  Adobe/XMP-Toolkit-SDK-CC201607/third-party/zlib
)

##
# generate Makefile and build
(   cd Adobe/XMP-Toolkit-SDK-CC201607
	cd build
	cmake . -G "Unix Makefiles" -DXMP_ENABLE_SECURE_SETTINGS=OFF -DXMP_BUILD_STATIC=1 -DCMAKE_CL_64=ON -DCMAKE_BUILD_TYPE=Release
	make
)
##
# copy built libraries and headers to XMPsdk
(   cd Adobe/XMP-Toolkit-SDK-CC201607
	cd public/libraries/macintosh/intel_64/release/
	ls -alt *.a
)

# That's all Folks!
##

##
# Apply changes (not needed, however keep this code, it may be useful later
# (   cd Adobe/XMP-Toolkit-SDK-CC201607
# 	if [ 1 == 2 ]; then (
# 		cd build/shared
# 		# modify CMakeUtils.sh to use "Unix Makefiles" instead of Xcode
# 		if [ -e CMakeUtils.sh.orig ]; then
# 			mv CMakeUtils.sh.orig CMakeUtils.sh
# 		fi
# 		cp CMakeUtils.sh CMakeUtils.sh.orig
#
# 		sed -E \
# 			 -e "s/is_makefile='OFF'/is_makefile='ON'/g" \
# 			 -e "s/Xcode/Unix Makefiles/g" \
# 			 -e "s/'xcode'/'gcc'/g" \
# 			 CMakeUtils.sh.orig > CMakeUtils.sh
# 		cd ..
# 		echo 3 | ./GenerateXMPToolkitSDK_mac.sh
# 		make VERBOSE=1
# 	); fi
# )

