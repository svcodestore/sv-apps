#!/bin/sh

docker-compose -f docker-compose.test.yaml down
docker-compose -f docker-compose.test.yaml up -d --build
