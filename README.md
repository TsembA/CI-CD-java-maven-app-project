# 🚀 CI/CD Pipeline for Dockerized Java App with Jenkins, Terraform, and AWS

This project demonstrates a complete CI/CD workflow using **Jenkins**, **Terraform**, **Docker**, and **AWS** to build, provision, and deploy a Java-based microservice in an automated pipeline.

---

## 📦 Technologies Used

- **Jenkins** – Orchestrates CI/CD pipeline
- **Docker & Docker Compose** – Containerizes and deploys the application
- **Terraform** – Provisions AWS infrastructure
- **AWS EC2, VPC, Security Groups** – Hosting the application
- **Maven** – Builds the Java application
- **GitHub** – Source code and shared library
- **DockerHub** – Image registry

---

## ⚙️ Pipeline Overview

The Jenkins pipeline (written in Groovy) performs the following stages:

### 1️⃣ Build Application
- Packages the Java Maven app into a `.jar`
- Uses shared library function: `buildJar()`

### 2️⃣ Build & Push Docker Image
- Builds image with `buildImage()`
- Logs into DockerHub
- Pushes image `tsemb/demo-app:jma-6.0`

### 3️⃣ Provision Infrastructure (Terraform)
- Provisions AWS:
  - VPC, Subnet, Internet Gateway, Route Table
  - Security Group (SSH, Port 8080)
  - EC2 instance with latest Amazon Linux 2 AMI
- Outputs EC2 public IP for deployment

### 4️⃣ Deploy to EC2
- Connects via SSH to EC2 instance
- Installs Docker & Docker Compose
- Logs into DockerHub
- Deploys the image using `docker-compose up -d`

---

## 🗂️ Repository Structure

```
├── Jenkinsfile
├── server-cmds.sh
├── docker-compose.yaml
├── terraform/
│   ├── main.tf
│   └── variables.tf
```

---

## 🔐 Security & Credentials (Managed in Jenkins)

- `github-credentials` – Access to shared library
- `dockerhub-creds` – DockerHub username/password
- `jenkins_aws_access_key_id`, `jenkins_aws_secret_access_key_id` – AWS access keys
- `server-ssh-key` – SSH access to EC2

---

## 🌍 Infrastructure Diagram

```
GitHub → Jenkins → DockerHub
             ↓
         Terraform
             ↓
          AWS EC2
             ↓
  Docker Compose (App + Postgres)
```

---

## 📸 Sample Output

After successful deployment, the application is accessible at:

```bash
http://<EC2_PUBLIC_IP>:8080
```

You can check logs via:

```bash
ssh ec2-user@<EC2_PUBLIC_IP>
docker ps
docker logs <container_id>
```

---

## 💼 Ideal For

✅ DevOps Engineer portfolio  
✅ Demonstrating end-to-end CI/CD automation  
✅ Showcasing Terraform IaaC skills  
✅ Real-world Docker and Jenkins implementation

---

## 📬 Contact

Created by **Арно** – DevOps Engineer | ex-Ballet Artist  
[LinkedIn](https://www.linkedin.com/in/your-link) • [GitHub](https://github.com/TsembA)

---

