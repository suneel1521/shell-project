#!/bin/bash
AMI_ID="ami-004d1eaf8eaa0107d"
INSTANCE_TYPE="t3.micro"
SG_NAME="sg-04cae0cb02562993b"
INSTANCE_NAME="project"

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --security-group-ids "$SG_NAME" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)
echo "Instance ID: $INSTANCE_ID"
echo "Instance Name: $INSTANCE_NAME"	