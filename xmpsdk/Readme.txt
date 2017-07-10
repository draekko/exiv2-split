
Adobe XMP SDK Instructions
==========================

Copy the include directory from the Adobe XMP SDK from the public directory into the exiv2 xmpsdk directory.

MacOS
=====

Compile the SDK.

Copy the generated files libXMPCoreStatic.a, and libXMPFilesStatic.a from the Adobe XMP SDK public folder.
Make sure to rename libXMPCoreStatic.a to libXMPCore.a, and rename libXMPFilesStatic.a to libXMPFiles.a as
well. Renaming the files can be using the ren-mac.sh bash script.


Linux
=====

Compile the SDK.

Copy the generated files staticXMPCore.a, and staticXMPFiles.a from the Adobe XMP SDK public folder.
Make sure to rename libXMPCoreStatic.a to libXMPCore.a, and rename libXMPFilesStatic.a to libXMPFiles.a as
well. Renaming the files can be using the ren-lnx.sh bash script.


Windows
=======

Compile the SDK.

Copy the generated files XMPCoreStatic.lib, and XMPFilesStatic.lib from the Adobe XMP SDK public folder.
Make sure to rename XMPCoreStatic.lib to libXMPCore.lib, and rename XMPFilesStatic.lib to libXMPFiles.lib
as well.
