# 🚀 Terraform AWS Infrastructure as Code (IaC)

## 👋 Welcome  
Welcome to my **Infrastructure as Code (IaC)** portfolio repository. This space showcases my hands-on journey in designing, provisioning, and managing cloud infrastructure using **Terraform** on **Amazon Web Services (AWS)**.

Instead of relying on the AWS Management Console, I focus on building **scalable, reusable, and automated infrastructure** through code—following modern **DevOps and Cloud Engineering best practices**.

---

## 📖 What You'll Find Here  
Each project in this repository is structured to provide both practical implementation and clear understanding:

- 📘 **Comprehensive Documentation** – Clear explanation of configurations and decisions  
- 🏗️ **Architecture Diagrams** – Visual representation of infrastructure design  
- ⚙️ **Step-by-Step Execution** – Terraform workflow (`init`, `plan`, `apply`)  
- 📸 **Proof of Work** – Screenshots of successfully deployed AWS resources  

---

## 🛠️ Project Portfolio  
Explore my Terraform projects below. Each project includes source code, documentation, and real deployment evidence.

<details>
  <summary><h2>📂<b> Click to View Projects (Serial No. 1–5)<b></h2></summary>

  <br/>

  | No. | Project Name | Description | Link |
  |:---:|:------------|:------------|:----:|
  | 01 | **AWS S3 Bucket Deployment** | Provisioning an S3 bucket with tagging and best practices. | [View Project 🔗](./terraform-aws-s3-Bucket) |
  | 02 | **Remote Backend & State Locking** | Secure Terraform state using S3 and DynamoDB locking. | [View Project 🔗](./terraform-aws-remote-backend) |
| 03 | **EC2 Nginx Web Server Setup** | Deploying a Linux EC2 instance, configuring Security Groups, and using `user_data` to automate Nginx installation. | [View Project 🔗](./terraform-aws-ec2-nginx-setup) |
| 04 | **EC2 Setup using Terraform Data Sources** | Dynamically fetching the latest Amazon Linux AMI using `data` blocks to ensure infrastructure is always up-to-date and portable. | [View Project 🔗](./terraform-aws-ec2-setup-DataSource) |
| 05 | S3 Static Website with CloudFront & Route53 | Deploying a static website on S3, secured with CloudFront (HTTPS), and accessible via a custom domain using Route53. | [View Project 🔗](./terraform-aws-s3-static-website-cloudfront-route53) |
</details>
---

## 🌱 Learning Goals & Growth Focus  
> 🎯 This section highlights the areas I am actively exploring and improving as I build more projects.

- **Deepening Terraform Expertise:** Writing cleaner, more efficient, and scalable configurations  
- **Cloud Architecture Understanding:** Designing reliable and cost-effective AWS solutions  
- **Automation Mindset:** Reducing manual effort through fully automated infrastructure workflows  
- **Problem-Solving Skills:** Debugging, optimizing, and improving infrastructure setups  
- **Consistency & Documentation:** Maintaining clear, professional, and well-documented projects  

---

## 📸 Documentation Preview  
Each project directory contains a dedicated `README.md` with:

- Architecture diagrams  
- Step-by-step execution guide  
- Deployment screenshots  
- Key learnings and insights

---

## 🖼️ Architecture & Project Spotlights
> [!TIP]
> This section provides a visual deep-dive into the infrastructure design for each implementation.

### 🔹 Project 05: S3 Static Website with CloudFront & Route53

**Overview:** Upgrades basic S3 hosting into a **production-ready, global web application**. It uses **CloudFront** to cache content at edge locations for fast, secure HTTPS delivery, and **Route53** to map a custom domain. The result is a serverless, scalable, and low-latency static website with enterprise-grade security.

<img width="1777" height="644" alt="image-1" src="https://github.com/user-attachments/assets/16afb599-25fd-4d59-924f-1a220f7dfbf4" />


### 🔹 Project 04: EC2 Setup using Data Sources
**Overview:** Demonstrates environment-agnostic code. By using the `aws_ami` Data Source, the configuration automatically fetches the latest Amazon Linux 2 AMI ID, ensuring the infrastructure is always patched and up-to-date.

**Architecture Diagram:**

<img width="1038" height="692" alt="architecture-image" src="https://github.com/user-attachments/assets/2efb18a7-73e2-4eca-8e3e-05aebc500b78" />


---

### 🔹 Project 03: EC2 Nginx Web Server
**Overview:** Full automation of the web server layer. Includes the creation of Security Groups for web traffic and uses a `user_data` script to bootstrap Nginx upon launch.

**Architecture Diagram:**

<img width="1491" height="757" alt="architecture" src="https://github.com/user-attachments/assets/fe80d7d2-bf5d-44ce-b43e-4af1bdd6b9e7" />

---

### 🔹 Project 02: Remote Backend & State Locking
**Overview:** Focuses on Team Collaboration. By offloading the state file to S3 and using DynamoDB for locking, this prevents state corruption during concurrent updates.

**Architecture Diagram:**

<img width="711" height="395" alt="pro-diagram" src="https://github.com/user-attachments/assets/94a753f0-9020-4612-bff7-61f734cf12b0" />

## How terrafrom State Behave

<img width="846" height="522" alt="state-Diagram" src="https://github.com/user-attachments/assets/7d7c32b5-d62c-4580-be3c-234d4d84698d" />

---

### 🔹 Project 01: AWS S3 Bucket Deployment
**Overview:** The foundation of cloud storage. This project implements a secure S3 bucket with versioning and public access blocks.

**Architecture Diagram:**

<img width="713" height="455" alt="Architecture" src="https://github.com/user-attachments/assets/46051ee2-cc75-443b-bd00-37a36e6d21ac" />

---

## 📫 Connect With Me  
I’m always open to discussing **DevOps, Cloud, and Infrastructure Engineering**.

- 🔗 [LinkedIn](https://www.linkedin.com/in/altamash-alam-129969289/)  
- 💻 [GitHub](https://github.com/altamashGit)  

---

## ✨ Final Note  
This repository is continuously evolving as I learn and implement new concepts in Terraform and AWS.

---

⭐ *Built with passion, consistency, and Terraform by Altamash Alam*
