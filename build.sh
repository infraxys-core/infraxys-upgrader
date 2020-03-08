#!/usr/bin/env sh

set -eo pipefail;

VERSION="$(cat VERSION)";

docker build -f Dockerfile -t quay.io/jeroenmanders/infraxys-upgrader:$VERSION .;

docker tag quay.io/jeroenmanders/infraxys-upgrader:$VERSION quay.io/jeroenmanders/infraxys-upgrader:latest
