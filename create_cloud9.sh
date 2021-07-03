#!/bin/bash

## CloudFormation実行
aws cloudformation create-stack \
--stack-name handson-cloud9 \
--template-body file://create_cloud9_env.yml \
--capabilities CAPABILITY_NAMED_IAM

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
  && echo ${ARRAY_EC2_INSTANCE_IDS}

EC2_INSTANCE_ID=$( \
  echo ${ARRAY_EC2_INSTANCE_IDS} \
    | sed 's/ .*$//' \
) \
  && echo ${EC2_INSTANCE_ID}

IAM_INSTANCE_PROFILE_ARN=$( \
  aws iam get-instance-profile \
    --instance-profile-name ${IAM_INSTANCE_PROFILE_NAME} \
    --query 'InstanceProfile.Arn' \
    --output text \
) \
  && echo ${IAM_INSTANCE_PROFILE_ARN}

STRING_EC2_INSTANCE_PROFILE="Arn=${IAM_INSTANCE_PROFILE_ARN},Name=${IAM_INSTANCE_PROFILE_NAME}" \
  && echo ${STRING_EC2_INSTANCE_PROFILE}

## 関連付け実行
aws ec2 associate-iam-instance-profile \
  --iam-instance-profile ${STRING_EC2_INSTANCE_PROFILE} \
  --instance-id ${EC2_INSTANCE_ID}

