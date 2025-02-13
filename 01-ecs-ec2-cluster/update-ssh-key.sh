#!/bin/bash

#
# Configuring environment variables for the AWS CLI
# https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html
#
AWS_PROFILE=cloudformation-deployment
SSH_KEY_NAME=ec2-sshkey

# To get the new keypair Id generated in the cloudformation template
KEYPAIR_ID=`aws ec2 describe-key-pairs \
    --filters Name=key-name,Values=${SSH_KEY_NAME} \
    --query 'KeyPairs[].KeyPairId' --output text`

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