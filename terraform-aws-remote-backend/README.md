---
# Terraform Remote Backend & State Management
---

This project is focused on managing Terraform state remotely instead of keeping it locally. The goal is to make infrastructure more secure, collaborative, and production-ready by using a remote backend.

---
## Project Architecture Diagram
<pro-diagram>

---
### Project Objective

In this project, I moved Terraform state from local storage to a remote backend (AWS S3). This helps in:

  -  Avoiding state file loss  
  -  Enabling team collaboration  
  -  Maintaining a single source of truth  
  -  Improving security and reliability

---
## Tech Stack
  -  Cloud Provider: AWS
  -  IaC Tool: Terraform (v1.x)
  -  Services Used:
        -   S3 (for storing state file)
        -   DynamoDB (for state locking)

---
## What I Implemented
  -   Created an S3 bucket to store Terraform state remotely
  -   Enabled versioning for state file safety
  -   Configured DynamoDB table for state locking
  -  Updated Terraform backend configuration

---

<state-Diagram>

## How Terraform Matches Desired vs Actual State
  Terraform compares two main things:

  ### 1. Desired State (Your Code)
  - Stored in .tf files  
  - This is what you want to create

  ### 2. Actual State
  - Stored in terraform.tfstate file  
  - This is what already exists

  ### 3. What Terraform Checks?
  Terraform reads:

  - `.tf files`      →  Desired state  
  - `.tfstate file`  →  Known actual state

Then it also checks the real infrastructure (AWS) to verify everything.


---
## Terraform State File (What & Why Important)
  ### 1. What is Terraform State File?

Terraform state file (terraform.tfstate) stores all the information about your infrastructure, such as:

Resource IDs  
Names  
Configuration details  
Current state of resources

 These are critical details that Terraform uses to manage your infra properly.
 
---
 ### 2. When is it Created?

It is created when you run terraform apply for the first time
After that, every time you run apply, Terraform updates the same state file

It’s continuously updated, not recreated every time.
---
  ### Why is it Important?

 - Keeps track of what Terraform has already created  
 - Helps Terraform know what to add, change, or delete  
 - Prevents duplication of resources

  Problem with local state:

 - Stored on your local machine  
 - Can be accessed or modified by others  
 - Causes conflicts when multiple people work on the same project

---

  ### 4. What Are We Doing to Solve This?

To avoid these issues, we use a remote backend (like AWS S3 + DynamoDB):

 - Store state file securely in S3  
 - Enable versioning for safety  
 - Use DynamoDB for state locking (avoid conflicts)

 This makes Terraform secure, collaborative, and production-ready

 ---

  ## 5. .tfstate.backup
 - Backup copy of the previous state  
 - Created automatically before updates  
 - Helps recover if something goes wrong

---
  ## 6. What is Remote Backend in Terraform?

A remote backend is a way to store your Terraform state file outside your local machine, usually in a shared and secure location like AWS S3.

Simple Understanding

Instead of saving terraform.tfstate locally, you store it in the cloud so multiple people can access and use it safely.

### Why We Use It
  - Enables team collaboration  
  - Keeps state file secure  
  - Prevents conflicts using locking (DynamoDB)  
  - Avoids losing state if your system crashes

---

  ## 7. “Lock Acquired” in Remote Backend?

When using a remote backend (like S3 + DynamoDB), Terraform uses state locking to prevent multiple users from making changes at the same time.
  1. S3 → stores state file
  2. DynamoDB → handles locking

 ---

## Setup S3 & DynamoDB for Remote State (Terraform)
 This setup is used to store your Terraform state remotely and enable locking.

create a Directory:

```bash
mkdir terraform-backend
```
---
## step 1. Create Resources (Local Backend First)
 
main.tf for creating resource S3 bucket and DynamoDB


# 1. s3 bucket for terraform state files
```hcl
resource "aws_s3_bucket" "terraform_statefiles_bucket" {
  bucket = "project-backend-terraform-statefiles231-bucket"
  tags = {
    Name = "my-terraform-statefiles-bucket"
    environment = "dev"
  }
}
```

# 2. dynamodb table for terraform state locking
```hcl
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "project-backend-terraform-locks-table12378"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```
---


## step 2. 2: Apply This First

```bash
terraform init
terraform apply
```
<backen-apply-image>
---

---
## verify on console
 S3 is created
 <s3-first-image>
 DynamoDb is creatd
 <DynamoDb-first-iamge> 
 ---

## Step 3: Configure Remote Backend

Back to the project directory

```bash
cd ..
```
### Now add backend config:  
```bash
nano terraform.tf
```
Then paste 

```hcl
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "project-backend-terraform-statefiles23178"
    key    = "dev/backend/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}
```
### for ec2 creation
```bash

#1. Key pair for EC2 instance state
```hcl
resource "aws_key_pair" "instance_key_pair" {
    key_name  = "state_key_pair"
    public_key = file("c:/users/altam/.ssh/id_ed25519.pub")
}
```

#2. Security group for EC2 instance state
```hcl
resource "aws_security_group" "ec2_instance_state-sg" {
    name        = "ec2_instance_state"
    description = "Security group for EC2 instance state"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
```
#3. Default VPC data source
```hcl
data "aws_vpc" "default" {
    default = true
}
```
# 4. EC2 instance for EC2 instance state 

```hcl
resource "aws_instance" "ec2_instance_state" {
    ami                    = "ami-05d2d839d4f73aafb"
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.instance_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.ec2_instance_state-sg.id]

    root_block_device {
        volume_size = 8
        volume_type = "gp2"
    }

    tags = {
        Name = "ec2_instance_state"
    }
}
```
---

Check syntext
```
terraform validate
```
preview & apply 
```
terraform plan
terraform apply
```
<main-apply-image>

---

## From Console Verify Instance
 
 <ec2-verify-iamge>

Note Public IP
now ssh to ec2 instance

```bash
ssh -i "C:/users/altam/.ssh/id_ed25519" ubuntu@13.233.255.64
```

<ssh-image>
---
## Virify that your terrraform state file is in S3 bucket.

### Here mention S3 bucket name and the path where state file will be store
```hcl
 backend "s3" {
    bucket = "project-backend-terraform-statefiles231-bucket"
    key    = "dev/backend/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
```
State file path `dev/backend/terraform.tfstate`

<s3-state-file-image>
Veify here
---
## Clean UP
delete your ec2
```bash
terraform destroy
```
<ec2 deleted>

move to s3 bucket terraform file
```bash
cd terraform-backend
```
Use this command 
```hcl
terraform destroy
```
<db-deleted>
---

Because Bucket is not empty so bucket will not delete
So that we are deleting through aws cli command
```bash
aws s3 rm s3://project-backend-terraform-statefiles231-bucket --recursive
```
Then

```bash
aws s3api delete-bucket --bucket project-backend-terraform-statefiles231-bucket
```
<bucket-delet-image>

---

### 🎉 Project End

This project has been successfully completed.
Infrastructure was provisioned, verified, and managed using Terraform with an S3 backend for secure state storage.
---