#!/usr/bin/env sh

set -eo pipefail;

if [ -n "$1" ]; then
  VERSION="$1";
else
  VERSION="$(cat VERSION)";
fi;

docker build -f Dockerfile -t quay.io/jeroenmanders/infraxys-upgrader:$VERSION .;

docker tag quay.io/jeroenmanders/infraxys-upgrader:$VERSION quay.io/jeroenmanders/infraxys-upgrader:latest
