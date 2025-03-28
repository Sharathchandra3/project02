import boto3
import os
import sys
from botocore.exceptions import ClientError

def create_key_pair(ec2, key_name):
    try:
        ec2.describe_key_pairs(KeyNames=[key_name])
        print(f"Key Pair '{key_name}' already exists. Using the existing key.")
    except ClientError:
        print(f"Key Pair '{key_name}' does not exist. Creating a new one...")
        key_pair = ec2.create_key_pair(KeyName=key_name)
        with open(f"{key_name}.pem", "w") as file:
            file.write(key_pair['KeyMaterial'])
        os.chmod(f"{key_name}.pem", 0o400)
        print(f"New Key Pair created and saved as {key_name}.pem")

def get_or_create_security_group(ec2, group_input):
    security_group_id = None
    try:
        if group_input.startswith("sg-"):
            response = ec2.describe_security_groups(GroupIds=[group_input])
            security_group_id = response['SecurityGroups'][0]['GroupId']
            print(f"Security Group ID '{group_input}' found. Using the existing group.")
        else:
            response = ec2.describe_security_groups(GroupNames=[group_input])
            security_group_id = response['SecurityGroups'][0]['GroupId']
            print(f"Security Group Name '{group_input}' found. Using the existing group.")
    except ClientError:
        print(f"Security Group '{group_input}' does not exist. Creating a new one...")
        response = ec2.create_security_group(GroupName=group_input, Description="Security group for EC2 instance")
        security_group_id = response['GroupId']
        # Allow SSH (port 22) and HTTP (port 80
