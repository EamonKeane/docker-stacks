#!/usr/bin/env bash

DOCKERFILE=scipy-notebook/Dockerfile
TAG=quay.io/eamonkeane/scipy-docker:1.2
CONTEXT="scipy-notebook"

docker build --file $DOCKERFILE --tag $TAG $CONTEXT
docker push $TAG

#docker tag quay.io/eamonkeane/scipy-docker:1 $TAG