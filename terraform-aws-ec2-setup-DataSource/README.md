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

<img width="1038" height="692" alt="architecture-image" src="https://github.com/user-attachments/assets/95217d91-99d8-4ed9-89dc-6034978c7845" />

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

<img width="1738" height="844" alt="ami-image" src="https://github.com/user-attachments/assets/ddc6362d-dc8e-47ea-b7f1-2c660db75860" />


---
1. Custom AMI via Data Source  

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
<img width="1074" height="702" alt="apply-iamge" src="https://github.com/user-attachments/assets/b3c7520c-7eda-4a8d-ba13-ac36368981a3" />

---
## Verify ami

<img width="1735" height="835" alt="console-output" src="https://github.com/user-attachments/assets/28028a5a-2fda-4df4-8720-6ba0a5f2a7df" />

---

---
## Project end

### Destroy and Cleanup

```bash
terraform destroy
```
<img width="1185" height="699" alt="destroy" src="https://github.com/user-attachments/assets/9e4c0310-d05d-465e-9209-6e8febe48582" />


---

Learning Outcome

✔ Understanding Terraform Data Sources  
✔ AWS Infrastructure provisioning  
✔ Clean DevOps workflow  
✔ Real-world Terraform usage  

---

🏁 Wrapping Up

This project may be small, but every line of Terraform brings me closer to mastering Infrastructure as Code.

Until the next deployment 🚀

Made with ❤️ using Terraform by Altamash
