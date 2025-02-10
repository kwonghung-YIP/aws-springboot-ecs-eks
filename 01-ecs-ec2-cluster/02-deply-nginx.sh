#!/bin/bash

STACK_NAME=ecs-nginx-svc

SSH_KEY_NAME=sshKeyECSCluster
CFN_EXECUTION_ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution

aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file nginx-taskdef-svc.yml \
    --stack-name ${STACK_NAME} \
    --capabilities CAPABILITY_IAM \
    --role-arn ${CFN_EXECUTION_ROLE_ARN} \
    --parameter-overrides SshKeyName=${SSH_KEY_NAME} #--debug

if [ $? -ne 0 ]
then
    exit 1
fi
