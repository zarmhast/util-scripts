#!/usr/bin/env sh
# Must be run as sudo
# Will install or upgrade fnm binary to a specified version
# Default version is the latest

# If version is not specified, retrieve it from github
PACKAGE_NAME=git-ecosystem/git-credential-manager
COMMAND_NAME=git-credential-manager
VERSION=${1:-$(echo "Retrieving current version" 1>&2 && curl -s https://api.github.com/repos/$PACKAGE_NAME/releases/latest|jq -r '.name'|cut -d' ' -f2 )}

command -v $COMMAND_NAME 1>>/dev/null 2>&1 && $COMMAND_NAME --version 2>&1| head -n1 | grep "^$VERSION\$" 1>>/dev/null && echo Already latest $VERSION && exit
echo Installing $PACKAGE_NAME:$VERSION

TARGET_DIR="$(command -v $COMMAND_NAME)"
if [ -n "$TARGET_DIR" ] ; then
	BIN_DIR="$(dirname "$TARGET_DIR")"
	TARGET_DIR="$(dirname "$(readlink -f "$TARGET_DIR")")"
elif [ "$(id -u)" = 0 ] ; then
	BIN_DIR=/usr/local/bin
	TARGET_DIR=/usr/local/lib/gcm-core
else
	BIN_DIR=~/.local/bin
	TARGET_DIR=~/.local/lib/gcm-core
fi

mkdir -p "$TARGET_DIR"
curl -L https://github.com/$PACKAGE_NAME/releases/download/v$VERSION/gcm-`uname -s`_amd64.$VERSION.tar.gz | tar zxC "$TARGET_DIR"
chmod -x "$TARGET_DIR"/*
chmod +x "$TARGET_DIR/$COMMAND_NAME"

ln -sf "$TARGET_DIR/$COMMAND_NAME" "$BIN_DIR/$COMMAND_NAME"
cp "$(dirname "$0")/git-credential-manager-wrapper" "$BIN_DIR"

git config --global --replace-all credential.helper manager-wrapper
git config --global credential.credentialstore secretservice
git config --global credential.usehttppath true
