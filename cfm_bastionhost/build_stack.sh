#!/bin/bash
# Script to build stack using Cloud formation for a web server
# Arguments: ACCESS SECRET

# Trick1:  Enable aws CLI completer (tab tab)
#          complete -C '/path/to/aws_completer' aws

# Trick2:  Command line options with live query of assets (e.g. instaance IDs)
#          pip install aws-shell
#          e.g. .edit

# CLI use requires credentails, region and output format
# Option 1:  aws configure (AccessKey, SecretKey, DefaulRegion and 
#            DefaultOutput [Text/JSON])
#            File is created in ~/.aws/config and credentials
#            Region name: us-east-1

# Option 2:  The calling instance must be a member of IAM role with
 #           appropriate access
 #           To view if current instance is part of an IAM role and
 #           information on its AccessKey,SecretKey, Token, etc:
 #           curl http://169.254.169.254/latest/meta-data/iam/
 #           security-credentials/ec2readonlyrole

# Order of Preference for Credentials:
#  (1) Command line options (but cannot pass access/secret)
#  (2) Env variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
#  (3) Credentials file ~/.aws/credentials or C:\Users\userid\.aws\credentials
#  (4) CLI config file ~/.aws/config or C:\...
#  (5) Instance profile credentials (IAM Policy -> IAM-Role -> EC2 Instance <-> STS)

# Credentials injected into script using env
# tuser/Attached policy: 
#   ViewOnlyAccess / Programatic Access Only (No Cosole)
#   PolicyCF / Custom policy to access CloudFormation
#	PolicySG / Custom policy to create & more EC2 Security Group
#   PolicyEIP / Custom policy to create & more EC2 EIP
#   PolicySG_EIP combined to allow all EC2
# Note;  If you override these env variables here then ~/.aws/credentials dont get used
#export AWS_ACCESS_KEY_ID=$1
#export AWS_SECRET_ACCESS_KEY=$2



# Test CLI
#aws ec2 describe-instances

# List current state of stacks associated with an account
#aws cloudformation describe-stacks

# Delete stack
#aws cloudformation delete-stack --stack-name webserver

# Create stack
aws cloudformation create-stack \
  --stack-name webserver \
  --template-body file://template.json \
  --parameters ParameterKey=VPC,ParameterValue=$VPC \
  ParameterKey=Subnet,ParameterValue=$SUBNET \
  ParameterKey=KeyPair,ParameterValue=$KEYPAIR \
  ParameterKey=AMI,ParameterValue=$AMI

# To check the outputs call
#aws cloudformation describe-stacks
#Outputs -> [OutputKey and OutputValue]
# To test machine
#ssh -i ~/Documents/gdit-aws/GDITKeyPair2.pem ec2-user@IP

# Few useful CloudFormation Pseudo Parameters (built-ins)
# AWS::AccountId
# AWS::NotificationARNs
# AWS::NoValue (Removes attribute)
# AWS::Region (Region of current stack)
# AWS::StackId (ID of current stack)
# AWS::StackName (Name of current stack)

# Few Fn functions:
# {"Fn::GetAZs": {"Ref": "AWS::Region"}}
# {"Fn"::Select": ["0", ["a", "b", "c", "d"]]}
# {"Fn::Join": [";", ["a", "b", "c"]]}
# Fn::GetAtt
# {"Fn::Base64": "A string"}