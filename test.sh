#!/usr/bin/env bash

docker-compose up
docker-compose down -v > /dev/null 2>&1
