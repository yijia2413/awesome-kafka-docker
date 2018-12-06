FROM anapsix/alpine-java:8
MAINTAINER Yi Jia<yijia2413@gmail.com>

RUN apk add --no-cache bash curl jq

ADD tars/kafka_*.tgz /opt
RUN mv /opt/kafka* /opt/kafka && \
    mkdir -p /opt/shells

ADD start-kafka.sh /opt/shells

HEALTHCHECK --start-period=10s CMD netstat -tuplen | grep 9092 || exit 1

CMD ["bash", "-c", "/opt/shells/start-kafka.sh"]
