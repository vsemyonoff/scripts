#!/bin/sh

# Check permissions
[ ! $UID == 0 ] && \
  echo "Error: only 'root' can use this script, exiting..." && \
    exit 1

###
# Build functions (override in configuration file)
###

PreConfigure()
{
  true
}

Configure()
{
  CFLAGS="$GCCFLAGS" \
  CXXFLAGS="$GCCFLAGS" \
  $CONFIGURE $CONFIGARGS
}

PostConfigure()
{
  true
}

PreBuild()
{
  true
}

Build()
{
  make -j3
}

PostBuild()
{
  true
}

PreInstall()
{
  true
}

Install()
{
  make install DESTDIR="$PKGDIR"
}

PostInstall()
{
  true
}

###
# Process package build configuration file
###

# Default "configure" args
CONFIGARGS="--prefix=/usr \
            --sysconfdir=/etc \
            --mandir=/usr/man \
            --infodir=/usr/info \
            --localstatedir=/var "

# Load configuration file
if [ "$#" == "0" ]; then
  echo "Error: configuration file not specified, exiting..."
  echo "Usage: $(basename $0) buildscript"
  exit 1
fi
BUILDSCRIPT="$1"
if [ -r "$BUILDSCRIPT" ]; then
  source "$BUILDSCRIPT"
else
  echo "Error: '$BUILDSCRIPT' file does not exists" \
       "(or not readable), exiting..."
  exit 1
fi

# Internal variables

# Build working directory
CWD="$(pwd)"
# Current source tarball location
SRCDIR="$CWD"

# Required settings

# Package name
#PKGNAME=""
# Package version
#VERSION=""
# One line package description
#DESCLINE=""
# Source archive name
#SOURCE=""
# Source URL(s)
#SRCURL[0]=""

# Optional settings

# Patch file(s)
#PATCH[0]=""
# Target architecture
ARCH=${ARCH:-"$(uname -m)"}
# Packager name and email
PACKAGER="${PACKAGER:-"$USER<$USER@$HOSTNAME>"}"
# Build number or builder abbreviation
BUILD=${BUILD:-"1"}
# Download tool name
DLTOOL=${DLTOOL:-"wget"}
# Download tool args
DLARGS=${DLARGS:-"-c"}
# Extract tool name
EXTRACTTOOL=${EXTRACTTOOL:-"tar"}
# Extract tool args for viewing archive
LISTARGS=${LISTARGS:-"tf"}
# Extract tool args for extraction
EXTRACTARGS=${EXTRACTARGS:-"xvf"}
# Source configuration tool name
CONFIGURE=${CONFIGURE:-"./configure"}
# Extend "configure" args
if [ "$CONFIGURE" == "./configure" ]; then
  CONFIGARGS="$CONFIGARGS \
              --with-compiledby=$PACKAGER \
              --build=$ARCH-pc-linux"
fi
# Build tool root folder
PKGROOT=${PKGROOT:-"/var/pkg"}
# Temporary root folder name
TMPDIR=${TMPDIR:-"$PKGROOT/src"}
# Ready to 'makepkg' packages folder name
BLDDIR=${BLDDIR:-"$PKGROOT/build"}
# Current package directory
PKGDIR=${PKGDIR:-"$BLDDIR/package-$PKGNAME-$VERSION"}
# Packages storage folder name
OUTDIR=${OUTDIR:-"$PKGROOT/packages"}

# Setup compiler flags
if [ "$ARCH" = "i486" ]; then
  GCCFLAGS="-O2 -march=i486 -mtune=i686"
elif [ "$ARCH" = "i686" ]; then
  GCCFLAGS="-O2 -march=i686 -mtune=i686"
elif [ "$ARCH" = "x86_64" ]; then
  GCCFLAGS="-m64 -O2 -fPIC"
fi

# Validate settings
[ "$PKGNAME" == "" ] && \
  echo "Error: package name is not defined, exiting..." && \
    exit 1
[ "$VERSION" == "" ] && \
  echo "Error: package version is not defined, exiting..." && \
    exit 1
[ "$DESCLINE" == "" ] && \
  echo "Error: package description is not defined, exiting..." && \
    exit 1
[ "$SOURCE" == "" ] && \
  echo "Error: package source archive name is not defined, exiting..." && \
  exit 1
[ "${SRCURL[0]}" == "" ] && \
  echo "Error: package source URL is not defined, exiting..." && \
    exit 1

###
# Build sources
###

# Download
if [ ! -r "$SRCDIR/$SOURCE" ]; then
  SRCDIR="$TMPDIR"
  if [ ! -r "$SRCDIR/$SOURCE" ]; then
    [ ! -x "$(which $DLTOOL)" ] && \
      echo "Error: '$DLTOOL' tool not installed, exiting..." && \
        exit 1
    mkdir -p "$SRCDIR" && cd "$SRCDIR"
    for i in $(seq 0 10000);
    do
      [ "${SRCURL[$i]}" == "" ] && \
        echo "Error: source URL empty, exiting..." && \
          exit 1
      "$DLTOOL" "$DLARGS" "${SRCURL[$i]}/$SOURCE" && DLOK="yes" && break
    done
    [ ! "$DLOK" == "yes" ] && exit 1
  fi
fi

# Extract
TOPDIR=$("$EXTRACTTOOL" "$LISTARGS" "$SRCDIR/$SOURCE" | head -1) || exit 1
mkdir -p "$TMPDIR" && cd "$TMPDIR" && \
  rm -rf "$PKGDIR" && mkdir -p "$PKGDIR" && \
    rm -rf "$TOPDIR" && mkdir -p "$OUTDIR" || exit 1
"$EXTRACTTOOL" "$EXTRACTARGS" "$SRCDIR/$SOURCE" && \
  cd "$TOPDIR" || exit 1

# Fix permissions
find . \( -perm 777 -o -perm 775 -o -perm 711 \) -exec chmod 755 {} \;
find . \( -perm 700 -o -perm 555 -o -perm 511 \) -exec chmod 755 {} \;
find . \( -perm 666 -o -perm 664 -o -perm 600 \) -exec chmod 644 {} \;
find . \( -perm 444 -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;
chown -R root:root .

# Patch
for i in $(seq 0 10000);
do
  [ "${PATCH[$i]}" == "" ] && break
  patch --batch --backup -p1 < "$CWD/${PATCH[$i]}" || exit 1
done

# Configure
PreConfigure || exit 1
Configure || exit 1
PostConfigure || exit 1

# Build
PreBuild || exit 1
Build || exit 1
PostBuild || exit 1

# Install
PreInstall || exit 1
Install || exit 1
PostInstall || exit 1

###
# Create Slackware/BlueWhite64 package
###

mkdir -p "$PKGDIR/install"
if [ -r "$CWD/slack-desc" ]; then
  cat "$CWD/slack-desc" > "$PKGDIR/install/slack-desc"
else
  cat << EOF > "$PKGDIR/install/slack-desc"
# HOW TO EDIT THIS FILE:
# The "handy ruler" below makes it easier to edit a package description.  Line
# up the first '|' above the ':' following the base package name, and the '|' on
# the right side marks the last column you can put a character in. You must make
# exactly 11 lines for the formatting to be correct.  It's also customary to
# leave one space after the ':'.

     |-----handy-ruler--------------------------------------------------------|
$PKGNAME:  Package     : $PKGNAME
$PKGNAME:  Version     : $VERSION
$PKGNAME:  Target ARCH : $ARCH
$PKGNAME:  Source URL  : ${SRCURL[0]}
$PKGNAME:
$PKGNAME:
$PKGNAME:  Description : $DESCLINE
$PKGNAME:
$PKGNAME:
$PKGNAME:
$PKGNAME:  Packager    : $PACKAGER
EOF
fi
[ -r "$CWD/doinst.sh" ] && \
  cat "$CWD/doinst.sh" > "$PKGDIR/install/doinst.sh"
# Make package freedesktop complaint
[ -r "$CWD/$PKGNAME.desktop" ] && \
  mkdir -p "$PKGDIR/usr/share/applications" && \
    cat "$CWD/$PKGNAME.desktop" > "$PKGDIR/usr/share/applications/$PKGNAME.desktop"

# Move documentation if any
mv -fv "$PKGDIR/usr/share/doc/$PKGNAME-$VERSION" "$PKGDIR/usr/doc" 2>/dev/null
mv -fv "$PKGDIR/usr/share/man" "$PKGDIR/usr" 2>/dev/null
mv -fv "$PKGDIR/usr/share/info" "$PKGDIR/usr" 2>/dev/null

# Store build script with documentation
mkdir -p "$PKGDIR/usr/doc/$PKGNAME-$VERSION"
cat "$CWD/$BUILDSCRIPT" > "$PKGDIR/usr/doc/$PKGNAME-$VERSION/$BUILDSCRIPT"

# Strip birnaies
( cd "$PKGDIR"
  find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null
  find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null
  find . | xargs file | grep "current ar archive" | cut -f 1 -d : | xargs strip -g 2> /dev/null
)

# Gzip man pages
if [ -d "$PKGDIR/usr/man" ]; then
  cd "$PKGDIR/usr/man"
  find . -type f -exec gzip -9 {} \;
  for i in $(find . -type l) ; do ln -s $( readlink $i ).gz $i.gz ; rm $i ; done
fi

# Gzip info pages
if [ -d "$PKGDIR/usr/info" ]; then
  cd "$PKGDIR/usr/info"
  rm -f dir
  gzip -9 *
fi

# Build Slackware/BlueWhite64 package
cd "$PKGDIR" && \
  chown -R root.root .
#if [ -x "$(which requiredbuilder)" ]; then
#   requiredbuilder -y -v -s "$CWD" "$PKGDIR"
#fi
/sbin/makepkg -l y -c n "$OUTDIR/$PKGNAME-$VERSION-$ARCH-$BUILD.txz"

# Generate checksum and desc
cd "$OUTDIR"
md5sum "$PKGNAME-$VERSION-$ARCH-$BUILD.txz" > \
  "$PKGNAME-$VERSION-$ARCH-$BUILD.txz.md5"
cat "$PKGDIR/install/slack-desc" | grep "^$PKGNAME" > \
  "$PKGNAME-$VERSION-$ARCH-$BUILD.txt"

# Remove source tree folder
rm -fr "$TMPDIR/$TOPDIR"

# End
