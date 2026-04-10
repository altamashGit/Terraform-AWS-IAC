---
# Terraform AWS EC2 using Data Sources
---
---
This project demonstrates how to provision an AWS EC2 instance using Terraform Data Sources, where the AMI is dynamically fetched from a custom image (snapshot-based AMI) instead of using a public AMI.

---

This approach is commonly used in production environments where:

Pre-configured images are required
Applications are already baked into the AMI
Faster deployment is needed.

---
# Architecture Flow
<architecture image>
---

## Tech Stack  
 .  AWS (EC2, VPC, Subnet, AMI, Snapshot)  
 . Terraform  
 . Terraform CLI
 ---

## Project Structure

```bash 
 .
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---
## Key Concepts Used
---
##  Custom AMI from Snapshot
In this project, instead of using a generic public AMI, I am using a custom AMI created from my own snapshot.

<ami_image>

---
1. Custom AMI via Data Source  
<ami-image>

Instead of using a public AMI, we fetch a custom AMI created from a snapshot:

```bash
data "aws_ami" "k8s" {
    owners = ["self"]
    most_recent = true
    filter {
    name   = "name"
    values = ["kubernetes-ami"]
  }
}
```
Explanation:

 . owners = ["self"] → Fetch AMIs from your AWS account  
 . Filter → Matches your custom AMI naming  pattern  
 . most_recent = true → Always pick latest version

---

## 2. EC2 Instance Using Custom AMI

```bash
resource "aws_instance" "web_site"{
    ami = data.aws_ami.k8s.id
    instance_type = var.instance_type
    subnet_id = data.aws_subnet.selected.id
    tags = {
        Name = "web-server-terra"
    }
}
```
Your EC2 will launch with:

 . Pre-installed software  
 . Pre-configured environment  
 . Faster startup time  
---
Workflow (Step-by-Step): 
1. DevOps Engineer runs Terraform  
2. Terraform CLI loads configuration  
3. Fetches:  
    .   Custom AMI (from snapshot-based image)  
    .   Subnet  
    .   Default VPC  
4. Launches EC2 instance using custom AMI
5. Instance starts with pre-baked configuration

---
Commands to Run:  

```bash
terraform init
terraform plan
terraform apply
```
<apply-iamge>
---
## Verify ami

<console-output>
---

---
## Project end

### Destroy and Cleanup

```bash
terraform destroy
```
<destroy-image>

---
Learning Outcome

✔ Understanding Terraform Data Sources
✔ AWS Infrastructure provisioning
✔ Clean DevOps workflow
✔ Real-world Terraform usage
---