#!/bin/bash

STACK_NAME=parent-stack

SSH_KEY_NAME=sshKeyECSCluster
CFN_EXECUTION_ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution
S3BUCKET_NAME=esc-ec2-cluster-cfn-templates

aws s3 cp parent-stack.yml s3://${S3BUCKET_NAME}/parent-stack.yml
aws s3 cp efs-nginx-shared.yml s3://${S3BUCKET_NAME}/efs-nginx-shared.yml
aws s3 cp ecs-ec2-cluster.yml s3://${S3BUCKET_NAME}/ecs-ec2-cluster.yml
aws s3 cp nginx-alb.yml s3://${S3BUCKET_NAME}/nginx-alb.yml
aws s3 cp nginx-ecs-svc.yml s3://${S3BUCKET_NAME}/nginx-ecs-svc.yml

aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file parent-stack.yml \
    --stack-name ${STACK_NAME} \
    --capabilities CAPABILITY_IAM \
    --role-arn ${CFN_EXECUTION_ROLE_ARN} \
    --parameter-overrides SshKeyName=${SSH_KEY_NAME} #--debug

if [ $? -ne 0 ]
then
    exit 1
fi