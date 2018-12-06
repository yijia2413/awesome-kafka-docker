#!/bin/bash

# kafka.sh run on Docker host machine
set -e

MAX_CONTAINERS=10

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${CUR_DIR}

if [[ $1 == 'build' ]]; then
    docker-compose up --force-recreate --build
elif [[ $1 == 'start' ]]; then
    docker-compose up -d
elif [[ $1 == 'stop' ]]; then
    docker-compose down
elif [[ "$1" =~ ^[0-9]+$ ]]; then
    if [[ $1 -gt ${MAX_CONTAINERS} || $1 -eq 0 ]]; then
        echo "Kafka containers can not be 0 or more than ${MAX_CONTAINERS}"
        echo "Please Check the numbers"
    else
        docker-compose up -d
        docker-compose up -d --scale kafka=$1 --no-recreate
    fi
else
    echo "Usage: kafka.sh [start|stop]"
    echo "or kafka.sh [num_kafka_containers]"
fi
