#!/usr/bin/env sh
# Must be run as sudo
# Will install or upgrade docker-compose binary to a specified version
# Default version is the latest

# If version is not specified, retrieve it from github
VERSION=${1:-$(echo "Retrieving current version" 1>&2 && curl -s https://api.github.com/repos/docker/compose/releases/latest|jq -r '.name')}

command -v docker-compose 1>>/dev/null 2>&1 && docker-compose -v | grep "version $VERSION," 1>>/dev/null && echo Already latest $VERSION && exit
echo Installing docker-compose:$VERSION

curl -L https://github.com/docker/compose/releases/download/$VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose && \
curl -L https://raw.githubusercontent.com/docker/compose/$VERSION/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
