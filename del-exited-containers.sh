#!/bin/bash

set -ex

containers=$(docker ps -a -q --filter status=exited)

if [[ ! -z ${containers} ]]; then
    docker rm -f -v ${containers}
fi

images=$(docker images | grep none | awk '{print $3}')

if [[ ! -z ${images} ]]; then
    docker rmi -f ${images}
fi
