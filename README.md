# awesome-kafka-docker
An awesome-kafka docker setup script, setup kafka cluster automaticlly

## Pre-Requisites
* install [docker](https://docs.docker.com/install/)
* install [docker-compose](https://docs.docker.com/compose/install/)

## Kafka Versions
You can modify `KAFKA_VERSION` and `SCALA_VERSION` in `donwload_kafka.sh` first as you like.

Current `KAFKA_VERSION=2.1.0`, `SCALA_VERSION=2.12`(Recommend)

Any kafka version >= 0.8.11 and scala version >= 2.10 will be fine.

## Setup
### build
```bash
# download kafka
sh download_kafka.sh

# create docker network
docker network create mykafka

# build images
sh kafka.sh build
```

### start
```bash
sh kafka.sh start
```

### scale to n kafka containers
```bash
sh kafka.sh [n]
# eg: sh kafka.sh 3
```

### stop kafka and zookeeper
```bash
sh kafka.sh stop
```

## Topics
### create topic
```bash
# create topic test001 with 1 partition and 1 replication-factor
sh topic.sh test001 create 

# create topic test002 with 3 partitions and 2 replication-factor
sh topic.sh test002 create 3 2
```

### describe topic
```bash
sh topic.sh test001 describe
```

### show all topics
```bash
sh topic.sh all list
```

## Produce and Consume
open 2 Terminal tabs, one for comsumer, another for producer

### Produce
in tab1, try:

```bash
# produce messages to topic test001
sh topic.sh test001 produce

# then you can type anyting you like when you see `>` and hit Enter
```

### Consume
in tab2, try:

```bash
sh topic.sh test001 consume

# you will see the `strings` you typed from tab1
```

## Tests
We use [Kafkacat](https://github.com/edenhill/kafkacat) for testing, you have to install it first.

> If you have any network problems here, please open an issue.

### consume
```bash
sh test.sh p
```

### produce
```bash
sh test.sh c
```

## Features
* auto create topic when consuming or producing, default partition is 1
* alpine java8, very small image, easy to scale out

## TODO
- [ ] Docker Swarm

## LICENSE
MIT
