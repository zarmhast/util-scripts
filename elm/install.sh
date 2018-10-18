#!/usr/bin/env sh
# Must be run as sudo
# Will install or upgrade docker-compose binary to a specified version
# Default version is the latest

# If version is not specified, retrieve it from github
PACKAGE_NAME=elm/compiler
VERSION=${1:-$(echo "Retrieving current version" 1>&2 && curl -s https://api.github.com/repos/$PACKAGE_NAME/releases/latest|jq -r '.name')}

command -v elm 1>>/dev/null 2>&1 && elm 2>&1| head -n1 | grep "Elm $VERSION." 1>>/dev/null && echo Already latest $VERSION && exit
echo Installing elm:$VERSION

curl -L https://github.com/$PACKAGE_NAME/releases/download/$VERSION/binaries-for-`uname -s`.tar.gz | tar xz -C /usr/local/bin/

