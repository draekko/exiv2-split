#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.61)
AC_INIT(exiv2, 0.26, ahuggel@gmx.net)
# See http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
EXIV2_LTVERSION=26:0:0
PACKAGE=$PACKAGE_NAME
VERSION=$PACKAGE_VERSION
AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE")
AC_DEFINE_UNQUOTED(VERSION, "$VERSION")
AC_SUBST(EXIV2_LTVERSION)
AC_SUBST(PACKAGE)
AC_SUBST(VERSION)
AC_CONFIG_SRCDIR([src/exif.cpp])
AC_CONFIG_HEADER([./config/config.h])
AC_CONFIG_AUX_DIR([./config])

AC_CHECK_FILES([${srcdir}/xmpsdk/include/XMP.hpp], , [echo "Did not find XMP SDK headers"; exit -1])
AC_CHECK_FILES([${srcdir}/xmpsdk/libXMPCore.a ${srcdir}/xmpsdk/libXMPFiles.a], , [echo "Did not find XMP SDK static lib"; exit -1])
XMP_A_SUPPORT=yes

# ---------------------------------------------------------------------------
# Checks for programs.
# ---------------------------------------------------------------------------
# Don't use -g to compile C++ code
ac_cv_prog_cxx_g=no
AC_PROG_CXX
AC_PROG_CXXCPP
AX_CXX_COMPILE_STDCXX(11, noext, optional)
# Don't use -g to compile C code
ac_cv_prog_cc_g=no
AC_PROG_CC
AC_PROG_CPP
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_CANONICAL_HOST

# ---------------------------------------------------------------------------
# i18n support
# ---------------------------------------------------------------------------
AM_GNU_GETTEXT([external])

# ---------------------------------------------------------------------------
# Libtool support
# ---------------------------------------------------------------------------
LT_INIT
AC_SUBST([LIBTOOL_DEPS])

# ---------------------------------------------------------------------------
# Checks for libraries.
# ---------------------------------------------------------------------------
AC_CHECK_LIBM()
LIBS="$LIBS $LIBM"
CHECK_ZLIB()
AC_SUBST(HAVE_LIBZ,$HAVE_LIBZ)
AM_ICONV

# ---------------------------------------------------------------------------
# Checks for header files.
# ---------------------------------------------------------------------------
AC_HEADER_STDC
AC_CHECK_HEADERS([libintl.h locale.h malloc.h stdint.h stdlib.h string.h unistd.h sys/mman.h utime.h regex.h])

# ---------------------------------------------------------------------------
# Checks for typedefs, structures, and compiler characteristics.
# ---------------------------------------------------------------------------
AC_HEADER_STDBOOL
AC_C_CONST
AC_C_INLINE
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_STRUCT_TM
#AC_TYPE_UINT8_T
#AC_TYPE_UINT16_T
#AC_TYPE_UINT32_T
#AC_TYPE_INT16_T
#AC_TYPE_INT32_T
AC_SUBST(GXX,$GXX)
AC_SUBST(GCC,$GCC)

# ---------------------------------------------------------------------------
# Checks for library functions.
# ---------------------------------------------------------------------------
#AC_FUNC_MKTIME - fails when using old autoconf with gcc-4.3, see eg. Debian Bug#425544, and we don't use the result anyway
AC_FUNC_MMAP
AC_FUNC_STRERROR_R
AC_CHECK_FUNCS([gmtime_r lstat memset mmap munmap strchr strerror strtol])
AC_CHECK_FUNCS([timegm], HAVE_TIMEGM=1)
AC_SUBST(HAVE_TIMEGM,$HAVE_TIMEGM)

# ---------------------------------------------------------------------------
# Miscellaneous
# ---------------------------------------------------------------------------
AC_MSG_CHECKING([whether to enable dependency tracking])
AC_ARG_ENABLE(dependency-tracking,
    [  --disable-dependency-tracking  speeds up one-time build],
    USE_TRACKING=$enableval, USE_TRACKING=yes)
AC_MSG_RESULT($USE_TRACKING)
DEP_TRACKING=
if test "$USE_TRACKING" = "yes"; then
    DEP_TRACKING=1
fi
AC_SUBST(DEP_TRACKING,$DEP_TRACKING)

AC_MSG_CHECKING([whether to enable symbol visibility support])
visibility=yes
# visibility support in cygwin/ming generates 1000's of warning, set off by default
case "$host_os" in
    *mingw* | *cygwin*) visibility=no  ;;
esac
AC_ARG_ENABLE(visibility,
    [  --disable-visibility    do not use symbol visibility support ],
    VISIBILITY_SUPPORT=$enableval, VISIBILITY_SUPPORT=$visibility)
AC_MSG_RESULT($VISIBILITY_SUPPORT)
if test "$VISIBILITY_SUPPORT" = "yes"; then
    # Sun Studio C++ compiler (which apparently ignores -fvisibility-inlines-hidden)
    AX_CXX_CHECK_FLAG(-xldscope=hidden,[],[],[VISIBILITY_SUPPORT=yes],[VISIBILITY_SUPPORT=no])
    if test "$VISIBILITY_SUPPORT" = "yes"; then
        CXXFLAGS="${CXXFLAGS} -xldscope=hidden"
    else
        # GNU g++
        AX_CXX_CHECK_FLAG(-fvisibility-inlines-hidden,[],[],[VISIBILITY_SUPPORT=yes],[VISIBILITY_SUPPORT=no])
        if test "$VISIBILITY_SUPPORT" = "yes"; then
           CXXFLAGS="${CXXFLAGS} -fvisibility=hidden -fvisibility-inlines-hidden"
        fi
    fi
    if test "$VISIBILITY_SUPPORT" = "yes"; then
        AC_DEFINE(WANT_VISIBILITY_SUPPORT)
    fi
    if test "$enable_shared" = "yes"; then
        AC_DEFINE(HAVE_DLL)
    fi
fi

AC_MSG_CHECKING([whether to use the lens database for Nikon lens names])
AC_ARG_ENABLE(lensdata,
    [  --disable-lensdata      do not use the lens database for Nikon lens names ],
    USE_LENSDATA=$enableval, USE_LENSDATA=yes)
AC_MSG_RESULT($USE_LENSDATA)
if test "$USE_LENSDATA" = "yes"; then
    AC_DEFINE(HAVE_LENSDATA,1)
fi

AC_MSG_CHECKING([whether to compile a commercial version of the Exiv2 library])
AC_ARG_ENABLE(commercial,
    [  --enable-commercial     compile with the EXV_COMMERCIAL_VERSION symbol set ],
    COMMERCIAL_VERSION=$enableval, COMMERCIAL_VERSION=no)
AC_MSG_RESULT($COMMERCIAL_VERSION)
AC_SUBST(COMMERCIAL_VERSION,$COMMERCIAL_VERSION)

AC_MSG_CHECKING([whether to compile with video support])
AC_ARG_ENABLE(video,
    [  --enable-video          compile with video support ],
    USE_VIDEO=$enableval, USE_VIDEO=no)
AC_MSG_RESULT($USE_VIDEO)
ENABLE_VIDEO=
if test "$USE_VIDEO" = "yes"; then
    ENABLE_VIDEO=1
    AC_DEFINE(ENABLE_VIDEO)
fi
AC_SUBST(ENABLE_VIDEO,$ENABLE_VIDEO)

AC_MSG_CHECKING([whether to compile with webready support])
AC_ARG_ENABLE(webready,
    [  --enable-webready       compile Exiv2 library with webready support ],
    ENABLE_WEBREADY=$enableval, ENABLE_WEBREADY=no)
AC_MSG_RESULT($ENABLE_WEBREADY)
if test "$enable_webready" = "yes"; then
    AC_DEFINE(ENABLE_WEBREADY)
fi

if test "$enable_webready" = "yes"; then
    # libcurl option might change flags, so we save them initially
    _cppflags="${CPPFLAGS}"
    _ldflags="${LDFLAGS}"

    AC_ARG_WITH(curl,
    [  --with-curl[[=DIR]]    use libcurl in DIR],[
      if test "$withval" != "no" -a "$withval" != "yes"; then
        CURL_DIR=$withval
        CPPFLAGS="${CPPFLAGS} -I$withval/include"
        LDFLAGS="${LDFLAGS} -L$withval/lib"
      fi
    ])

    USE_CURL=
    if test "$with_curl" != "no"; then
        # Check for libcurl library
        found_curl=yes
        CURL_CPPFLAGS=
        CURL_LDFLAGS=
        CURL_LIBS=
        AC_CHECK_HEADERS(curl/curl.h,
            AC_CHECK_LIB(curl, curl_easy_init,[
                USE_CURL=yes
                AC_DEFINE([USE_CURL], [1], [Use libcurl library])
                CURL_LIBS="-lcurl"
                if test "x${CURL_DIR}" != "x"; then
                    CURL_CPPFLAGS="-I${CURL_DIR}/include"
                    CURL_LDFLAGS="-L${CURL_DIR}/lib"
                fi],[found_curl=no]),[found_curl=no])
        if test "$found_curl" = "no"; then
            AC_MSG_ERROR(either specify a valid curl installation with --with-curl=DIR or use --without-curl)
        fi
        AC_SUBST(CURL_CPPFLAGS)
        AC_SUBST(CURL_LDFLAGS)
        AC_SUBST(CURL_LIBS)
    fi
    CPPFLAGS=${_cppflags}
    LDFLAGS=${_ldflags}

    # libssh option might change flags, so we save them initially
    _cppflags="${CPPFLAGS}"
    _ldflags="${LDFLAGS}"

    AC_ARG_WITH(ssh,
    [  --with-ssh[[=DIR]]    use libssh in DIR],[
      if test "$withval" != "no" -a "$withval" != "yes"; then
        SSH_DIR=$withval
        CPPFLAGS="${CPPFLAGS} -I$withval/include"
        LDFLAGS="${LDFLAGS} -L$withval/lib"
      fi
    ])

    USE_SSH=
    if test "$with_ssh" != "no"; then
        # Check for libssh library
        found_ssh=yes
        SSH_CPPFLAGS=
        SSH_LDFLAGS=
        SSH_LIBS=
        AC_CHECK_HEADERS(libssh/libssh.h,
            AC_CHECK_LIB(ssh, ssh_new,[
                USE_SSH=1
                AC_DEFINE([USE_SSH], [1], [Use libssh library])
                SSH_LIBS="-lssh"
                if test "x${SSH_DIR}" != "x"; then
                    SSH_CPPFLAGS="-I${SSH_DIR}/include"
                    SSH_LDFLAGS="-L${SSH_DIR}/lib"
                fi],[found_ssh=no]),[found_ssh=no])
        if test "$found_ssh" = "no"; then
            AC_MSG_ERROR(either specify a valid libssh installation with --with-ssh=DIR or use --without-ssh)
        fi
        AC_SUBST(SSH_CPPFLAGS)
        AC_SUBST(SSH_LDFLAGS)
        AC_SUBST(SSH_LIBS)
    fi
    AC_SUBST(USE_SSH,$USE_SSH)
    CPPFLAGS=${_cppflags}
    LDFLAGS=${_ldflags}
fi

# expat option might change flags, so we save them initially
_cppflags="${CPPFLAGS}"
_ldflags="${LDFLAGS}"

AC_ARG_WITH(expat,
[  --with-expat[[=DIR]]    use libexpat in DIR],[
  if test "$withval" != "no" -a "$withval" != "yes"; then
    EXPAT_DIR=$withval
    CPPFLAGS="${CPPFLAGS} -I$withval/include"
    LDFLAGS="${LDFLAGS} -L$withval/lib"
  fi
])

    # Check for expat library
    found_expat=yes
    EXPAT_CPPFLAGS=
    EXPAT_LDFLAGS=
    EXPAT_LIBS=
    PTHREAD_LIBS=
    if test "$with_expat" != "no"; then
        AC_CHECK_HEADERS(expat.h,
            AC_CHECK_LIB(expat, XML_ParserCreate,[
                AC_DEFINE([HAVE_EXPAT], [], [Have Expat XML parser library])
                EXPAT_LIBS="-lexpat"
                if test "x${EXPAT_DIR}" != "x"; then
                    EXPAT_CPPFLAGS="-I${EXPAT_DIR}/include"
                    EXPAT_LDFLAGS="-L${EXPAT_DIR}/lib"
                fi],[found_expat=no]),[found_expat=no])
        PTHREAD="-lpthread"
    fi
    if test "$with_expat" = "no" -o "$found_expat" = "no"; then
    AC_MSG_ERROR(either specify a valid expat installation with --with-expat=DIR)
    fi
    AC_SUBST(EXPAT_CPPFLAGS)
    AC_SUBST(EXPAT_LDFLAGS)
    AC_SUBST(EXPAT_LIBS)
    AC_CHECK_LIB(pthread, pthread_create, [PTHREAD_LIBS+=-lpthread])
    AC_SUBST(PTHREAD_LIBS)

CPPFLAGS=${_cppflags}
LDFLAGS=${_ldflags}

# Udi's hack to add libiconv to the Libs section in exiv2.pc
if test "$enable_shared" = "no"; then
    EXV_LIB_STATIC=$LTLIBICONV
else
    EXV_LIB_STATIC=
fi
AC_SUBST(EXV_LIB_STATIC)

# Add flag for DLL on Windows
#
# This must happen after all other configure checks, because
# the "-no-undefined" flag is only for libtool and must not be
# passed to GCC by accident.
# version.cpp requires link to psapi/Windows and dl/Unix builds
case "$host_os" in
*mingw* | *cygwin*)
    LDFLAGS="$LDFLAGS -no-undefined -lpsapi -lwldap32 -lws2_32" ;;
*linux-gnu*)
    LDFLAGS="$LDFLAGS -ldl -lpthread" ;;
*)
    LDFLAGS="$LDFLAGS -lpthread" ;;
esac

# 1099
for u in gettext msginit msgmerge msgfmt msgconv msgfilter ; do
    if test "$USE_NLS" = "yes" ; then
        which "$u" 2>/dev/null > /dev/null
        if test "$?" != "0" ; then
            echo "*** utility ${u} is not on the PATH     Disabling NLS support ***"
            USE_NLS=no
        fi
    fi
done

AC_DEFUN([AX_GCC_VERSION], [
  GCC_VERSION=""
  AX_CHECK_COMPILE_FLAG([-dumpversion],
     [ax_gcc_version_option=yes],
     [ax_gcc_version_option=no])

  AS_IF([test "x$GCC" = "xyes"],[
    AS_IF([test "x$ax_gcc_version_option" != "xno"],[
      AC_CACHE_CHECK([gcc version],[ax_cv_gcc_version],[
        ax_cv_gcc_version="`$CC -dumpversion`"
        AS_IF([test "x$ax_cv_gcc_version" = "x"],[
          ax_cv_gcc_version=""
        ])
      ])
      GCC_VERSION=$ax_cv_gcc_version
    ])
  ])
  AC_SUBST([GCC_VERSION])
])

case "$host_os" in
*darwin*)
    AC_ARG_WITH(sysroot,
    [  --with-sysroot[[=DIR]]    use OSX SDK in DIR],[
        if test "$withval" != ""; then
           SDK_SYSROOT=${withval}
           CPPFLAGS="${CPPFLAGS} -isysroot ${SDK_SYSROOT} "
        fi
    ])
    AC_ARG_WITH(min-target-sdk,
    [  --with-min-target-sdk[[=SDKREV]]    use minimum sdk target of (ie. 10.9) ],[
        if test "$withval" != ""; then
          SDK_MIN_TARGET=${withval}
          CPPFLAGS="${CPPFLAGS} -mmacosx-version-min=${SDK_MIN_TARGET} "
        fi
    ])
    ;;
esac

AC_ARG_ENABLE(stdcpp11,
    [  --disable-stdcpp11    do not use the c++11 standard ],
    STDCPP11_SUPPORT=$enableval, STDCPP11_SUPPORT=$visibility)
AC_MSG_RESULT($STDCPP11_SUPPORT)
if test "$STDCPP11_SUPPORT" = "yes"; then
    CPPFLAGS="${CPPFLAGS} -std=c++11 -DEXV_USING_CPP_ELEVEN"
else

# 1188 v0.26 uses c++98
# 1188 v0.27 should have an option to specify versions such as c++11
case "$host_os" in
    *cygwin*)
        CPPFLAGS="$CPPFLAGS -std=gnu++98"  # cygwin requires gnu++98 to support snprintf
    ;;
    *ming*)
        CPPFLAGS="$CPPFLAGS"               # mingw doesn't link pthreads if you specify -std !!
    ;;
    *)
        CPPFLAGS="$CPPFLAGS -std=c++98"
        if [[ ! -z "$GCC_VERSION" ]]; then
            if [[ "$GCC_VERSION" -ge 6 ]]; then CPPFLAGS="$CPPFLAGS -std=gnu++98" ; fi  # // not GCC 6
        fi
    ;;
esac
fi

if test "$XMP_A_SUPPORT" = "yes"; then
    CPPFLAGS="${CPPFLAGS} -DEXV_HAVE_XMP_TOOLKIT"
fi

# ---------------------------------------------------------------------------
# Create output files.
# ---------------------------------------------------------------------------
AC_CONFIG_FILES([./Makefile:./config/Makefile.in])
AC_CONFIG_FILES([./config/config.mk])
AC_CONFIG_FILES([./config/exiv2.pc])
AC_CONFIG_FILES([./po/Makefile.in])
AC_CONFIG_FILES([./src/doxygen.hpp])
AC_OUTPUT

# ---------------------------------------------------------------------------
# Configuration summary.
# ---------------------------------------------------------------------------

echo ""
echo "------------------------------------------------------------------"
echo "-- Exiv2 $VERSION feature configuration summary"
echo "--"

case "$enable_shared" in
yes) echo "-- Build a shared library......... YES" ;;
*)   echo "-- Build a shared library......... NO" ;;
esac

case "$VISIBILITY_SUPPORT" in
yes) echo "-- Use symbol visibility support.. YES" ;;
*)   echo "-- Use symbol visibility support.. NO" ;;
esac

case "x$HAVE_LIBZ" in
x1)  echo "-- PNG image support.............. YES" ;;
*)   echo "-- PNG image support.............. NO"
     echo ""
     echo "zlib is required for PNG support. Make sure the zlib header files"
     echo "are installed and use --with-zlib=DIR if it is in a non-standard"
     echo "location. You can get zlib from http://www.zlib.net/"
     echo "" ;;
esac

case "$USE_NLS" in
yes) echo "-- Native language support........ YES" ;;
*)   echo "-- Native language support........ NO"
     echo ""
     echo "gettext is required for native language support. Make sure the"
     echo "gettext header files and utilities are installed. "
     echo "You can get gettext from http://www.gnu.org/software/gettext/"
     echo "" ;;
esac

case "$USE_LENSDATA" in
yes) echo "-- Nikon lens database............ YES" ;;
*)   echo "-- Nikon lens database............ NO" ;;
esac

case "x$ENABLE_VIDEO" in
x1)  echo "-- Video support.................. YES" ;;
*)   echo "-- Video support.................. NO"
esac

if test "$enable_webready" = "yes"; then
    echo  "-- Webready support............... YES"
else
    echo  "-- Webready support............... NO"
fi

if test "$enable_webready" = "yes"; then
case "$USE_CURL" in
yes) echo "-- Using Lib Curl................. YES" ;;
*)   echo "-- Using Lib Curl................. NO"
     echo ""
     echo "Libcurl is required for HttpIo in basicIo.cpp. Make sure the Curl header"
     echo "files are installed and use --with-curl=DIR if it is in a"
     echo "non-standard location. You can get Curl from"
     echo "http://curl.haxx.se/libcurl/"
     echo "" ;;
esac

case "x$USE_SSH" in
x1)  echo "-- Using Lib SSH.................. YES" ;;
*)   echo "-- Using Lib SSH.................. NO"
     echo ""
     echo "Libssh is required for SshIo in basicIo.cpp. Make sure the libssh header"
     echo "files are installed and use --with-ssh=DIR if it is in a"
     echo "non-standard location. You can get libssh from"
     echo "http://www.libssh.org/get-it/"
     echo "" ;;
esac
fi

case "$host_os" in
*darwin*)
    if [ "$SDK_SYSROOT" != "" ]; then
        echo "-- Using SysRoot.................. $SDK_SYSROOT"
    fi
    if [ "$SDK_MIN_TARGET" != "" ]; then
        echo "-- Using Min. Target SDK ......... $SDK_MIN_TARGET"
    fi
    ;;
esac

echo "------------------------------------------------------------------"
echo ""

# That's all Folks!
##
