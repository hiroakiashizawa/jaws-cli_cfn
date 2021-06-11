#!/bin/bash

## CloudFormation実行


## Instance Profile関連付け
### 変数設定
EC2_INSTANCE_TAG_PREFIX='aws-cloud9-handson-cloud9-env'
IAM_INSTANCE_PROFILE_NAME='handson-cloud9-instance-profile'
ARRAY_EC2_INSTANCE_IDS=$( \
  aws ec2 describe-instances \
    --filters Name=tag-key,Values=Name \
              Name=tag-value,Values=${EC2_INSTANCE_TAG_PREFIX}* \
    --query Reservations[].Instances[].InstanceId \
    --output text \
) \
EC2_INSTANCE_ID=$( \
  echo ${ARRAY_EC2_INSTANCE_IDS} \
    | sed 's/ .*$//' \
) \
STRING_EC2_INSTANCE_PROFILE="Arn=${IAM_INSTANCE_PROFILE_ARN},Name=${IAM_INSTANCE_PROFILE_NAME}"

## 関連付け実行
aws ec2 associate-iam-instance-profile \
  --iam-instance-profile ${STRING_EC2_INSTANCE_PROFILE} \
  --instance-id ${EC2_INSTANCE_ID}

