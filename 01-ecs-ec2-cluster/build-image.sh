#!/bin/bash

NGINX_VERSION="1.27.4"
IMAGE_TAG="kwonghung/aws-ecs-nginx:${NGINX_VERSION}"
#ALB_DOMAIN="www.abc.com" 
ALB_DOMAIN="nginx-ecs-svc-alb-1788272757.eu-north-1.elb.amazonaws.com"

docker buildx build \
    --build-arg VERSION=${NGINX_VERSION} \
    --tag ${IMAGE_TAG} \
    nginx

docker push ${IMAGE_TAG}

docker stop nginx

docker run --name nginx -d --rm \
    -p 80:80 \
    -e ALB_DOMAIN_NAME=${ALB_DOMAIN} \
    ${IMAGE_TAG}

sleep 5

curl -v localhost:80

curl -v -H "Host:${ALB_DOMAIN}" localhost:80/test.txt

#docker exec -it nginx /bin/bash
