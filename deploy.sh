#!/bin/bash
S3_BUCKET="kinesis-agent-demo-eder-2021"

echo "Checking if bucket exists ..."
if ! aws s3 ls $S3_BUCKET ; then
    echo "S3 bucket named $S3_BUCKET does not exist. will Create"
    aws s3 mb s3://$S3_BUCKET
else
    echo "Bucket already exist"
fi

#aws s3api wait object-exists --bucket kinesis-agent-demo-eder-2021 --key artifacts.zip
result=$(aws s3api head-object --bucket $S3_BUCKET --key artifacts.zip 2>&1)
if echo "$result" | grep -q "Not Found"; then
    echo "deploy artifacts ... "
    cd ./log-generator && zip -r ../artifacts.zip . && cd ../
    aws s3 cp artifacts.zip s3://$S3_BUCKET/artifacts.zip
else
    echo "Artifacts already exist"
fi

default_vpc_id=$(aws ec2 describe-vpcs \
    --filters Name=isDefault,Values=true \
    --query 'Vpcs[*].VpcId' \
    --output text)

echo $default_vpc_id

aws cloudformation deploy --stack-name aws-kinesis-agent-resources --template-file template.yaml \
    --capabilities CAPABILITY_IAM --parameter-overrides vpcId=$default_vpc_id