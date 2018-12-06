#!/bin/bash

set -ex

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TARS_DIR="${CUR_DIR}/tars"
mkdir -p ${TARS_DIR}

KAFKA_VERSION=2.1.0
SCALA_VERSION=2.12
KAFKA_URL="http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
wget ${KAFKA_URL} -O ${TARS_DIR}/$(basename ${KAFKA_URL})
