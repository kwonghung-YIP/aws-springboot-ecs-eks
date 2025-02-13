#!/bin/bash

STACK_NAME=ecs-nginx-svc

aws cloudformation delete-stack \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME}
    
STACK_NAME=ecs-ec2-cluster

aws cloudformation delete-stack \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME}

