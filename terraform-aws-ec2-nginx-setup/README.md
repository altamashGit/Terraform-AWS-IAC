---
# Terraform AWS EC2 Nginx Deployment
---

---
*Overview*

This project demonstrates how to use Terraform to provision an AWS EC2 instance and automatically configure it with Nginx using User Data. The 
deployed instance serves a basic web page over HTTP (Port 80).

---

---
## Architecture

<img width="1491" height="757" alt="architecture" src="https://github.com/user-attachments/assets/1ffb7736-6940-4dcd-84f3-a29a5498f245" />


---

---
Project Structure
.
├── main.tf          # Main Terraform configuration  
├── variables.tf     # Input variables  
├── outputs.tf       # Outputs (e.g., public IP)  
├── provider.tf      # AWS provider config   
└── README.md        # Project documentation

---
## Tech Stack (Short)
AWS (EC2) – Cloud infrastructure
Terraform – Infrastructure as Code
Nginx – Web server (Port 80)
Bash (User Data) – Instance setup automation
Linux (Ubuntu) – Operating system
Terraform CLI – Deployment tool
---

---
### Key Concept

*Provider*
   – A plugin that allows Terraform to interact with cloud platforms like AWS.

*Resource*
   – A defined infrastructure component such as an EC2 instance created by Terraform.

*Variable*
    – A parameter used to make Terraform configurations reusable and flexible.

*User Data*
   – A startup script that runs automatically when an EC2 instance is launched.

*EC2 Instance*
   – A virtual server in AWS used to run applications.

*Nginx*
   – A high-performance web server used to serve web content over HTTP.

---

---

## Terraform Configuration
    ### Provider (AWS)
```bash
provider "aws" {
    alias = "mumbai"
    region = var.aws_region
  
}
```
---

---
### EC2 Instance Resource
```bash
    resource "aws_key_pair" "terraform_key_pair" {
    key_name   = "local_key_pair"
    public_key = file(var.key_path)
}

resource "aws_security_group" "terraform_ec2_sg" {
    name       = "terraform-ec2-sg"
    description = "Security group for Terraform EC2 instance"

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


resource "aws_instance" "terraform_ec2_instance" {
    count             = var.server_count
    ami               = var.ami_id
    instance_type     = var.instace_type
    key_name          = aws_key_pair.terraform_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.terraform_ec2_sg.id]

    user_data = file("user_data.sh")
    
  root_block_device {
        volume_size = var.volume_size
        volume_type = "gp2"
  }
    tags = {
        Name = "${var.instance_name}-${count.index + 1}"
    } 
}
```
---

---
### user_data.sh (Nginx Setup)

```bash
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>Welcome to Terraform EC2 Instance</h1>" | sudo tee /var/www/html/index.html
```
---


---
### Variable (variable.tf)
```bash
variable "aws_region" {
    description = "The AWs region to deploy the ec2 instance"
    type = string
    default = "ap-south-1"
}

variable "instace_type" {
    description = "The type of instance to start"
    type        = string
    default     = "t2.micro"  
}

variable "ami_id" {
    description = "The AMI ID to use for the instance"
    type        = string
    default     = "ami-"
  
}

variable "key_path" {
    description = "The path to the SSH key pair for accessing the instance"
    type        = string
    default     = "c:/users/altam/.ssh/id_ed25519.pub"  
}

variable "server_count" {
    description = "The number of instances to create"
    type        = number
    default     = 1
  
}


variable "instance_name" {
    description = "The name to assign to the instance"
    type        = string
    default     = "Terraform-EC2-Instance"
  
}

variable "volume_size" {
    description = "The size of the EBS volume in GB"
    type        = number
    default     = 8  
}
```
### Outputs (output.tf)
```bash
output "instance_public_ips" {
  value = aws_instance.terraform_ec2_instance[*].public_ip
}

output "instance_dns_names" {
  value = aws_instance.terraform_ec2_instance[*].public_dns
}

output "instance_ids" {
  value = aws_instance.terraform_ec2_instance[*].id
  }
```

---

---
## Deployment Steps

### Initalize Terraform
```bash
terraform init
```
### Validate configuration
```bash
 terraform validate
``` 
### Preview changes
```bash
terraform plan
```
### Apply configuration
```bash
 terraform apply
 ```
<img width="1109" height="722" alt="apply" src="https://github.com/user-attachments/assets/b5f3a630-b3e1-4712-ad13-d434998cf14a" />


### Ec2 console

<img width="1706" height="817" alt="ec2-console" src="https://github.com/user-attachments/assets/fde47fd1-dbb9-442f-a77d-da08d39d08a0" />

---

## Access the Application

### After deployment:  
 - Get the EC2 public IP:  
```bash
terraform output
```  

<img width="848" height="137" alt="output" src="https://github.com/user-attachments/assets/c70c5df9-e88b-495b-a339-1298dabec057" />

---
 - Open in browser:  

```bash
http://<public-ip>  
```
---

<img width="1860" height="751" alt="browser" src="https://github.com/user-attachments/assets/0b43475f-8d7b-4422-bc2d-d01214926a36" />


### Result
 - EC2 instance running on AWS  
 - Nginx installed automatically  
 - Web server accessible via browser  

---
## Cleanup

To destroy resources:

```bash
terraform destroy
```

<img width="1145" height="748" alt="destroy" src="https://github.com/user-attachments/assets/da530110-1fb7-4fee-a964-df19ebaac673" />

---

---
---
## Conclusion

This project demonstrates a simple yet powerful DevOps workflow using   Terraform to automate infrastructure provisioning and application setup on AWS.
---
---
