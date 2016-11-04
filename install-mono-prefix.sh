#!/bin/sh
if [ $# -ne 1 ]; then
	echo "Usage: install-mono.sh </path/to/mono/installation>"
	exit 1
fi

MSBUILD_TOOLSVERSION=15.0
MONO_PREFIX=$1
MSBUILD_OUT_DIR="bin/Debug-MONO/OSX_Deployment"
MSBUILD_INSTALL_BIN_DIR="$MONO_PREFIX/lib/mono/msbuild/${MSBUILD_TOOLSVERSION}/bin"
XBUILD_DIR=$MONO_PREFIX/lib/mono/xbuild

mkdir -p $MSBUILD_INSTALL_BIN_DIR
mkdir -p $XBUILD_DIR/$MSBUILD_TOOLSVERSION

cp -r $MSBUILD_OUT_DIR/ $MSBUILD_INSTALL_BIN_DIR
mv $MSBUILD_INSTALL_BIN_DIR/Microsoft.Common.props $XBUILD_DIR/$MSBUILD_TOOLSVERSION

rm $MSBUILD_INSTALL_BIN_DIR/*UnitTests*
rm $MSBUILD_INSTALL_BIN_DIR/*xunit*
rm $MSBUILD_INSTALL_BIN_DIR/NuGet*
rm $MSBUILD_INSTALL_BIN_DIR/System.Runtime.InteropServices.RuntimeInformation.dll

cp -R nuget-support/tv/ $XBUILD_DIR/$MSBUILD_TOOLSVERSION
cp -R nuget-support/tasks-targets/ $XBUILD_DIR/

for f in $XBUILD_DIR/Microsoft/NuGet/*; do ln -s $f $XBUILD_DIR ; done

sed -e 's,@bindir@,'$MONO_PREFIX'/bin,' -e 's,@mono_instdir@,'$MONO_PREFIX/lib/mono',' msbuild-mono-deploy.in > msbuild-mono-deploy.tmp
chmod +x msbuild-mono-deploy.tmp
cp msbuild-mono-deploy.tmp $MONO_PREFIX/bin/msbuild
