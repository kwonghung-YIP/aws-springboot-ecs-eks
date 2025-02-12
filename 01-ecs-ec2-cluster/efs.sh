#!/bin/bash

STACK_NAME=efs-nginx-shared

SSH_KEY_NAME=sshKeyECSCluster
CFN_EXECUTION_ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution

# aws cloudformation validate-template \
#     --template-body file://efs.yml

aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file efs.yml \
    --stack-name ${STACK_NAME} \
    --capabilities CAPABILITY_IAM \
    --role-arn ${CFN_EXECUTION_ROLE_ARN} #--debug

if [ $? -ne 0 ]
then
    exit 1
fi
