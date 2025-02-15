#!/bin/bash

#
# Configuring environment variables for the AWS CLI
# https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html
#
AWS_PROFILE=cloudformation-deployment

BOOTSTRAP_STACK_NAME=bootstrap-stack
BOOTSTRAP_ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution

echo "Create bootstrap stack:${BOOTSTRAP_STACK_NAME}..."

aws cloudformation deploy \
    --template-file cloudformation/00-bootstrap.yml \
    --stack-name ${BOOTSTRAP_STACK_NAME} \
    --role-arn ${BOOTSTRAP_ROLE_ARN} \
    --no-fail-on-empty-changeset \
    --output json

if [ $? -ne 0 ]
then
    exit 1
fi

BUCKET_NAME=`aws cloudformation describe-stacks \
    --stack-name ${BOOTSTRAP_STACK_NAME} \
    --query 'Stacks[0].Outputs[?OutputKey==\`BucketName\`].OutputValue' \
    --output text --no-cli-pager`

echo "Extract Bucket Name:${BUCKET_NAME} for uploading nested CloudFormation template file..."

aws s3 cp cloudformation/ s3://${BUCKET_NAME}/ \
    --recursive --include "*.yml" --exclude "00-bootstrap.yml"

if [ $? -ne 0 ]
then
    exit 1
fi

STACK_NAME=parent-stack
ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution

echo "Create parent stack:${STACK_NAME}..."

aws cloudformation deploy \
    --template-file cloudformation/01-parent-stack.yml \
    --stack-name ${STACK_NAME} \
    --role-arn ${ROLE_ARN} \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides BucketName=${BUCKET_NAME} #--debug

if [ $? -ne 0 ]
then
    exit 1
fi

# To get the new keypair Id generated in the cloudformation template
KEYPAIR_ID=`aws cloudformation describe-stacks \
    --stack-name ${STACK_NAME} \
    --query 'Stacks[0].Outputs[?OutputKey==\`SshKeyPairId\`].OutputValue' \
    --output text --no-cli-pager`

echo "Extract the Keypair ID:${KEYPAIR_ID} just generated in parent stack..."

if [ -z "${KEYPAIR_ID}" ];
then
    exit 1
fi

echo "Extract the new keypair's primary key from systems manager parameter store..."

# Extract the primary key form systems parameters properties
aws ssm get-parameter \
    --name /ec2/keypair/${KEYPAIR_ID} \
    --with-decryption --query Parameter.Value --output text > ~/.ssh/id_ed25519

echo "Update .ssh with the new key..."
# Change the ssh private key file and not allow access by others
chmod 700 ~/.ssh/id_ed25519