#!/usr/bin/env bash

set -e

docker-compose up -d

function container_is_running() {
    local CONTAINER_NAME=$1
    out=$(docker container inspect "${CONTAINER_NAME}")
    return $?
}

sleep 10s

KAFKA_CONTAINER_NAME="kafka"
container_is_running "${KAFKA_CONTAINER_NAME}" || true
rc=$?
[ $rc -eq 0 ] && {
    docker exec -it "${KAFKA_CONTAINER_NAME}" kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic square --replication-factor 1
    docker exec -it "${KAFKA_CONTAINER_NAME}" kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic cube   --replication-factor 1
}

echo "Kafka Topics: "
docker exec -it "${KAFKA_CONTAINER_NAME}" kafka-topics.sh --bootstrap-server localhost:9092 --list
