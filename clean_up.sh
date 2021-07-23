#!/bin/bash
S3_BUCKET="kinesis-agent-demo-eder-2021"

aws s3 rm s3://$S3_BUCKET/ --recursive 2>&1
aws s3api delete-bucket --bucket $S3_BUCKET 2>&1
aws cloudformation delete-stack --stack-name aws-kinesis-agent-resources
echo "deleting stack ....."
aws cloudformation wait stack-delete-complete --stack-name aws-kinesis-agent-resources
echo "Stack deleted"

aws s3 ls