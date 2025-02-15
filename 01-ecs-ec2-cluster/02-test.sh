#!/bin/bash

AWS_PROFILE=cloudformation-deployment

ALB_DOMAIN=`aws cloudformation describe-stacks \
    --stack-name parent-stack \
    --query 'Stacks[0].Outputs[?OutputKey==\`ALBPublicDomainName\`].OutputValue' \
    --output text --no-cli-pager`

watch -n 2 curl -v -s http://${ALB_DOMAIN}/test.txt
