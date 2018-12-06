#!/bin/bash

set -eu

# Usage:
# test.sh run on Docker Host Machine
# You have to build kafkacat on your host
# Ref: https://github.com/edenhill/kafkacat

# Produce
# kafkacat -b ip:port,ip1:port1 -P -t test
# Consume
# kafkacat -b ip:port,ip1:port1 -C -t test

KAFKA_TOPIC="test1"
HOST_IP="localhost"

KAFKA_PORTS=$(docker ps | grep "9092/tcp" | awk '{print $(NF-1)}' | cut -d ":" -f2 | cut -d "-" -f1)
BROKERS=''

if [[ -z ${KAFKA_PORTS} ]]; then
    echo "Please start kafka containers first"
    echo "See kafka.sh"
    exit 1
fi

# Concat ports
for kafka_port in ${KAFKA_PORTS}; do
    BROKERS+="${HOST_IP}:${kafka_port},"
done

# Remove last ,
BROKERS=$(echo ${BROKERS} | sed 's/,$//')

if [[ $1 == 'p' ]]; then
    # Produce
    echo "helloworld" | kafkacat -b ${BROKERS} -P -t ${KAFKA_TOPIC}
elif [[ $1 == 'c' ]]; then
    # Consume
    kafkacat -b ${BROKERS} -C -t ${KAFKA_TOPIC}
else
    echo "Usage: test.sh [c|p]"
    echo "c means consume"
    echo "p means produce"
fi
