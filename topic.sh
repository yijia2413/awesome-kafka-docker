#!/bin/bash
set -e

# topic.sh run on Docker Host Machine

TOPIC=$1

# Accept actions are:
#   list: list all topics
#   create: create one topic
#   describe: describe one topic
#   consume: consume from one topic from beginning
#   produce: produce message to kafka topic

ACTION=${2:-"list"}                 # default to list all topics
NUM_PARTITIONS=${3:-1}              # default partition num = 1
NUM_REPLICATION_FACTOR=${4:-1}      # default replication factor = 1

if [[ $# -lt 1 ]]; then
    echo "Usage: topic.sh <topic_name> [actions] [num_topic_partitions] [num_replication_factor]"
    echo "Example1: topic.sh test1 create"
    echo "Example3: topic.sh test1 create 3 2"
    echo "Example3: topic.sh test1 desc"
    echo "Example4: topic.sh test1 consume"
    echo "Example5: topic.sh test1 produce"
    echo "Example5: topic.sh test1 list"
    exit 10
fi

KAFKA1=$(docker ps | grep "kafka_kafka_1" | grep "9092/tcp" | awk '{print $1}')
if [[ -z ${KAFKA1} ]]; then
    echo "Please start kafka containers first"
    echo "See kafka.sh"
    exit 10
fi

KAFKA_BROKERS=$(docker ps | grep "kafka_kafka" | grep "9092/tcp" | awk '{print $1}')
BROKERS=''
for broker in ${KAFKA_BROKERS}; do
    BROKERS+="${broker}:9092,"
done
# Remove last ,
BROKERS=$(echo ${BROKERS} | sed 's/,$//')

# show all topics
if [[ ${ACTION} == "list" ]]; then
    docker exec -it ${KAFKA1} bash -c "/opt/kafka/bin/kafka-topics.sh --zookeeper zkdocker:2181 --${ACTION}"
fi

# create topic
if [[ $# -eq 4  && ${ACTION} == "create" || ${ACTION} == "create" ]]; then
    docker exec -it ${KAFKA1} bash -c "/opt/kafka/bin/kafka-topics.sh --zookeeper zkdocker:2181 --${ACTION} --topic ${TOPIC} --partitions ${NUM_PARTITIONS} --replication-factor ${NUM_REPLICATION_FACTOR}"
fi


# describe one topic
if [[ ${ACTION} == "describe" ]]; then
    docker exec -it ${KAFKA1} bash -c "/opt/kafka/bin/kafka-topics.sh --zookeeper zkdocker:2181 --topic ${TOPIC} --${ACTION}"
fi

# console producer
if [[ ${ACTION} == "produce" ]]; then
    docker exec -it ${KAFKA1} bash -c "/opt/kafka/bin/kafka-console-${ACTION}r.sh --broker-list ${BROKERS} --topic ${TOPIC}"
fi

# console consumer
if [[ ${ACTION} == "consume" ]]; then
    docker exec -it ${KAFKA1} bash -c "/opt/kafka/bin/kafka-console-${ACTION}r.sh --bootstrap-server ${BROKERS} --topic ${TOPIC} --from-beginning"
fi
