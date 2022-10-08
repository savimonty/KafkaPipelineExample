#!/usr/bin/env bash

set -a
source ../.env
set +a

set -o pipefail

pipe=/tmp/testpipe

trap "rm -f $pipe" EXIT
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

(
    tail -f $pipe | docker exec -i kafka kafka-console-producer.sh \
        --broker-list localhost:9092 \
        --topic square
)& 

while true
do
    if read line; then
        if [[ "$line" == 'quit' ]]; then
            break
        fi
        echo "$line" >> $pipe
    fi
done

