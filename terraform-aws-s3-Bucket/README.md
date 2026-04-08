---

#  AWS S3 Bucket Provisioning with Terraform

---
I built this project to understand how Infrastructure as Code (IaC) actually works in a real setup.The main idea behind this was to stop relying on the AWS Console and instead manage infrastructure through code — making everything cleaner, reusable, and version-controlled.

---

## Architecture diagram

<img width="713" height="455" alt="Architecture" src="https://github.com/user-attachments/assets/dfd20a5b-e706-4ccd-ac73-6c5588883c5f" />


---

### Tech Stack I Used 
Cloud Provider: AWS  
IaC Tool: Terraform (v1.x)  
Language: HCL (HashiCorp Configuration Language)  
Service: AWS S3  

---

 How to Get Started
✅ Prerequisites

Before running this project, make sure you have:  

 . AWS CLI installed and configured (aws configure)  
 . Terraform installed on your system  
 . Proper IAM permissions to create S3 buckets   

---

---

### What is terraform....?
 ---> Terraform is an Infrastructure as Code (IaC) tool used to create and manage infrastructure using code instead of manual setup.

It allows you to configure resources like servers, storage, networking, and databases.

    . Uses HCL (HashiCorp Configuration Language)  
    . Configuration files are saved with .tf extension  
    . Terraform reads these files and provisions infrastructure on cloud providers like AWS

---

 ### Provider in Terraform
  ---> A provider in Terraform is a plugin that allows Terraform to interact with a specific platform or service.

provider "aws" → using AWS

```.tf
provider "aws" {
    alias = "mumbai"
    region = "ap-south-1"
}
```
---
### Understand Blocks in Terraform

 --> Blocks are the main building units in Terraform configuration.

They define different parts of your infrastructure like provider, resources, variables, etc  

IN Simple words: A block is just a section of code with a specific purpose.
  
 #### Common Blocks    
   . provider → connects to cloud (AWS, Azure, gcp , etc..)  
   . resource → creates infrastructure  
   . variable → input values  
   . output → shows results  

---

---
### Terraform Resource (S3 Bucket) 

  --> This block is used to create an S3 bucket in AWS
    
    ```bash
    resource "aws_s3_bucket" "demo_project_bucket" {
         bucket = "demo-with-project-bucket-terraform"
          tags = {
             Name = "my-demo-project-bucket" 
             environment = "dev"
              }
            }
    ```


---

 ### Terraform init
  --> terraform init is similar to git init.

When you run it, Terraform initializes your working directory and prepares it to manage infrastructure.

  .  It downloads required provider plugins (like AWS)  
  .  Sets up the backend for storing state  
  .  Prepares the environment for Terraform commands

<img width="961" height="546" alt="init" src="https://github.com/user-attachments/assets/8a123539-8123-4d64-a970-ba667dda146e" />


---

### Terraform validate
  --> terraform validate is used to check whether your Terraform configuration files are syntactically correct and valid.

After writing your .tf files, you run this command to make sure there are no errors before applying changes.

  . Checks for syntax errors  
  . Verifies configuration structure  
  . Shows errors with suggestions if something is wrong

<img width="414" height="75" alt="validate" src="https://github.com/user-attachments/assets/8d5b7308-81a1-44e7-9a86-c7cff18ea3aa" />

---

### Terraform plan
   --> terraform plan is used to preview what changes Terraform will make before actually applying them.

It compares your .tf configuration with the current state and shows:

  . What resources will be created
  . What will be updated
  . What will be deleted

If there are any issues (like deprecated or incorrect configurations), it will show errors or warnings.

<img width="592" height="879" alt="plan" src="https://github.com/user-attachments/assets/1ea5c770-6fc2-48a7-9676-aad932464d93" />

---

### Terraform Apply
   --> terraform apply is used to create or update infrastructure based on your .tf files.
   . It executes the changes shown in terraform plan  
   . Creates, updates, or deletes resources  
   . Asks for confirmation before applying

<img width="818" height="856" alt="apply" src="https://github.com/user-attachments/assets/ef604200-f8a7-4c01-9571-f3e1bf6df248" />


---

### Verify S3 Bucket in AWS Console:
   1. Go to S3 service
   2. Check for bucket name: demo-with-project-bucket-terraform
   3. Verify tags and details

<img width="1920" height="1032" alt="bucket-image" src="https://github.com/user-attachments/assets/b16376f7-6319-4dc5-801f-5e6c92ccfd17" />


<tag images>

---
## Ending the Project (Cleanup)

To finish this project, you should delete the resources created by Terraform.

### Command
```bash
terraform destroy
```

What It Does  
    .   Deletes the S3 bucket you created  
    .   Removes all managed resources  
    .   Cleans up your infrastructure

You’ll be asked for confirmation → type yes

<img width="666" height="911" alt="Screenshot 2026-04-05 133559" src="https://github.com/user-attachments/assets/ce934ae9-f849-4f8f-91e6-864cc82f65dc" />


---
