#!/usr/bin/env bash

docker-compose up test
docker-compose down -v > /dev/null 2>&1
