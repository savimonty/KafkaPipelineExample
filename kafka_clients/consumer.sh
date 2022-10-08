#!/usr/bin/env bash

set -o pipefail

pipe=/tmp/testpipe-topic-$1

trap "rm -f $pipe" EXIT
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi


if [ $1 == "square" ]
then
    echo "Consuming topic '$1' and producing ^2 to topic 'cube'"
    docker exec -i kafka kafka-console-consumer.sh --topic $1 --bootstrap-server localhost:9092 \
        | xargs -i sh -c 'x={} && echo $((x*$x))' \
        | tee /dev/tty \
        | docker exec -i kafka kafka-console-producer.sh --broker-list localhost:9092 --topic cube
else
    echo "Consuming topic '$1' and cubing input"
    docker exec -i kafka kafka-console-consumer.sh --topic $1 --bootstrap-server localhost:9092 \
        | xargs -i sh -c 'x={} && echo $((x*$x*$x))'
fi
