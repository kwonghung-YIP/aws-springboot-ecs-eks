#!/bin/bash

NGINX_VERSION="1.27.4"

IMAGE_TAG="kwonghung/aws-ecs-nginx:${NGINX_VERSION}"

docker buildx build \
    --build-arg VERSION=${NGINX_VERSION} \
    --tag ${IMAGE_TAG} \
    nginx

docker push ${IMAGE_TAG}