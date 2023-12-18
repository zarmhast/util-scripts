#!/usr/bin/env sh
# Must be run as sudo
# Will install or upgrade fnm binary to a specified version
# Default version is the latest

# If version is not specified, retrieve it from github
PACKAGE_NAME=schniz/fnm
VERSION=${1:-$(echo "Retrieving current version" 1>&2 && curl -s https://api.github.com/repos/$PACKAGE_NAME/releases/latest|jq -r '.name'|cut -b2- )}

command -v fnm 1>>/dev/null 2>&1 && fnm --version 2>&1| head -n1 | grep "fnm $VERSION" 1>>/dev/null && echo Already latest $VERSION && exit
echo Installing $PACKAGE_NAME:$VERSION

ZIP_TMP_FILE="$( mktemp --tmpdir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)/}" --suffix=.zip )"
trap "rm -f $ZIP_TMP_FILE" EXIT
curl -L https://github.com/$PACKAGE_NAME/releases/download/v$VERSION/fnm-`uname -s`.zip -o "$ZIP_TMP_FILE"

TARGET_DIR="$(command -v fnm)"
[ -n "$TARGET_DIR" ] && TARGET_DIR="$(dirname "$TARGET_DIR")" || {
	[ "$(id -u)" = 0 ] && TARGET_DIR=/usr/local/bin || TARGET_DIR=~/.local/bin
}

unzip -d "$TARGET_DIR" -o "$ZIP_TMP_FILE"
chmod +x "$TARGET_DIR"/fnm
