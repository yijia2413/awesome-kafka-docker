#!/bin/bash

set -ex

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${CUR_DIR}
mkdir -p ${CUR_DIR}/hosts

# backup old hosts file
suf=$(date '+%Y%m%d%H%M%S')
cp /etc/hosts ${CUR_DIR}/hosts/hosts.${suf}

HOSTNAMES=$(docker ps | grep "kafka_kafka" | grep "9092/tcp" | awk '{print $1}')

for hostname in ${HOSTNAMES}; do
    docker_ip=$(docker exec -it ${hostname} bash -c "ifconfig" \
        | grep "inet addr" | grep "Bcast" | grep "Mask" \
        | awk '{print $2}' | cut -d ":" -f2)

    echo "${docker_ip}  ${hostname}" >> /etc/hosts
done

tail -n 10 /etc/hosts
