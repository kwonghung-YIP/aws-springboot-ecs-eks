#!/bin/bash

AWS_PROFILE=cloudformation-deployment

function empty_bucket {
    BUCKET_NAME=$1

    OBJECTS=`aws s3api list-object-versions \
        --bucket ${BUCKET_NAME}`

    if [ -z "${OBJECTS}" ];
    then
        return 0
    fi

    JSON=`echo $OBJECTS|jq -r '{Objects:.Versions|map({Key:.Key,VersionId:.VersionId}),Quiet:true}'`

    aws s3api delete-objects \
        --bucket ${BUCKET_NAME} \
        --delete "${JSON}"
}

for BUCKET_NAME in $(aws s3api list-buckets \
    --query "Buckets[*].Name" --output text)
do
    echo "Empty Bucket:${BUCKET_NAME}..."
    empty_bucket ${BUCKET_NAME}
done

echo "Delete parent-stack..."

aws cloudformation delete-stack \
    --stack-name parent-stack

echo "Delete bootstrap-stack..."

aws cloudformation delete-stack \
    --stack-name bootstrap-stack

for LOG_GROUP in $(aws logs describe-log-groups \
    --query 'logGroups[].logGroupName' --output text)
do
    #echo ${LOG_GROUP}
    aws logs delete-log-group \
        --log-group-name ${LOG_GROUP}
done