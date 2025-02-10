#!/bin/bash

STACK_NAME=ecs-ec2-cluster

SSH_KEY_NAME=sshKeyECSCluster
CFN_EXECUTION_ROLE_ARN=arn:aws:iam::796973491384:role/springboot-ec2-cloudformation-execution

aws cloudformation deploy \
    --profile cloudformation-deployment \
    --template-file ecs-cluster-stack.yml \
    --stack-name ${STACK_NAME} \
    --capabilities CAPABILITY_IAM \
    --role-arn ${CFN_EXECUTION_ROLE_ARN} \
    --parameter-overrides SshKeyName=${SSH_KEY_NAME} #--debug

if [ $? -ne 0 ]
then
    exit 1
fi

# To get the new keypair Id generated in the cloudformation template
KEYPAIR_ID=`aws ec2 describe-key-pairs \
    --filters Name=key-name,Values=${SSH_KEY_NAME} \
    --query 'KeyPairs[].KeyPairId' --output text`

echo $KEYPAIR_ID

# Extract the primary key form systems parameters properties
aws ssm get-parameter \
    --name /ec2/keypair/${KEYPAIR_ID} \
    --with-decryption --query Parameter.Value --output text > ~/.ssh/id_ed25519

# Change the ssh private key file and not allow access by others
chmod 700 ~/.ssh/id_ed25519

# Report the Stack Output, include the public DNS of the Application Load Balancer
aws cloudformation describe-stacks \
    --profile cloudformation-deployment \
    --stack-name ${STACK_NAME} \
    --query 'Stacks[0].Outputs[].OutputValue' \
    --no-cli-pager