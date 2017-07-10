# Powershell Script

# Copyright (c) 2008-2015, Gilles Caulier, <caulier dot gilles at gmail dot com>
# 
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

function not-exist { -not (Test-Path $args) }
Set-Alias !exist not-exist -Option "Constant, AllScope"
Set-Alias exist Test-Path -Option "Constant, AllScope"

# We will work on command line
$MAKEFILES_TYPE="Visual Studio 14 2015 Win64"

if ( not-exist build.cmake )
{
    mkdir build.cmake
}

cd build.cmake

$depotdir="C:\Users\anyuser\pathtocode"
$zlibdir="zlib-1.2.8"
$expatdir="expat-2.1.0"
$exiv2dir="exiv2-0.26"

# Paths to required  files
$zpath = "$depotdir\$zlibdir;"
$epath = "$depotdir\$expatdir;$depotdir\$expatdir\lib;$depotdir\$expatdir\xmlwf;"

# Paths to required library files
$lzpath = "$depotdir\zlibd.lib"
$lepath = "$depotdir\expatd.lib"

cmake -G "$MAKEFILES_TYPE" . -DZLIB_INCLUDE_DIR:PATH="$zpath" -DZLIB_LIBRARY="$lzpath" -DEXPAT_INCLUDE_DIR:PATH="$epath" -DEXPAT_LIBRARY="$lepath" -DEXIV2_ENABLE_SHARED=ON -DEXIV2_ENABLE_XMP=ON -DEXIV2_ENABLE_PNG=ON -DEXIV2_ENABLE_NLS=ON -DEXIV2_ENABLE_PRINTUCS2=ON -DEXIV2_ENABLE_LENSDATA=ON -DEXIV2_ENABLE_COMMERCIAL=OFF -DEXIV2_ENABLE_BUILD_SAMPLES=OFF -DEXIV2_ENABLE_BUILD_PO=ON -DEXIV2_ENABLE_VIDEO=ON -DEXIV2_ENABLE_WEBREADY=OFF -DEXIV2_ENABLE_CURL=OFF -DEXIV2_ENABLE_SSH=OFF -Wno-dev ..

Write-output "To compile do :"
Write-output "    cmake --build . --config Debug"
Write-output "    or"
Write-output "    cmake --build . --config Release"

