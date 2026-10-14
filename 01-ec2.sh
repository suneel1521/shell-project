#!/bin/bash

AMI_ID="ami-004d1eaf8eaa0107d"
INSTANCE_TYPE="t3.micro"
SG_NAME="sg-04cae0cb02562993b"
INSTANCES=("frontend" "mysql" "python" "radis" "user" "cart" "shopping")

for instance in "${INSTANCES[@]}"
do
    INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --security-group-ids "$SG_NAME" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text)
	if [ "$instance" != "frontend" ]
    then
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)
    else
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
    fi

    echo "$instance IP address: $IP"
done