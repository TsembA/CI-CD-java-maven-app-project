🚀 Project Description: CI/CD Pipeline with Jenkins and Terraform on AWS

This project automates the build, infrastructure provisioning, and deployment of a containerized Java application using Jenkins, Docker, Terraform, and AWS.

🔁 CI/CD Pipeline Overview (Jenkinsfile)
The Jenkins pipeline performs the following automated stages:

1. Build Application

Uses Maven to compile and package the Java application into a JAR file using a shared library function: buildJar().
2. Build and Push Docker Image

Builds a Docker image using buildImage(IMAGE_NAME).
Logs into DockerHub using credentials stored in Jenkins.
Pushes the Docker image (tsemb/demo-app:jma-6.0) to DockerHub via dockerPush(IMAGE_NAME).
3. Provision Infrastructure with Terraform

Uses stored AWS credentials to initialize and apply Terraform code.
Spins up:
A new VPC
Subnet, Internet Gateway, Route Table
Security Group
Amazon Linux EC2 Instance (AMI fetched dynamically)
Outputs the public IP of the EC2 instance for deployment.
4. Deploy Application to EC2

Waits 90 seconds for EC2 initialization.
Uses scp to copy:
docker-compose.yaml
server-cmds.sh (bash setup & deploy script)
Executes server-cmds.sh remotely via SSH, which:
Installs Docker & Docker Compose
Logs in to DockerHub
Runs the container with the pulled image
☁️ Infrastructure (Terraform)
Your main.tf defines:

🔹 VPC Setup

Custom VPC and Subnet
Public access via Internet Gateway
Routing through default route table

🔹 Security Configuration

Default Security Group:
Allows SSH (22) only from your IP and Jenkins IP
Allows HTTP traffic (8080) from anywhere
Allows all outbound traffic


🔹 EC2 Instance

Uses latest Amazon Linux 2 AMI
Type defined by variable (var.instance_type)
Public IP enabled
SSH key name: myapp-key


🔹 Output

Public IP of EC2 instance (output "ec2_public_ip")
📦 Deployment Script (server-cmds.sh)
Once executed via SSH on the EC2 instance, this script:

Installs Docker and Docker Compose
Logs into DockerHub
Sets up .env with the image name
Uses docker-compose to deploy the containerized app
🔒 Credentials & Secrets (in Jenkins)
github-credentials: Access to shared library
dockerhub-creds: For DockerHub login
jenkins_aws_access_key_id & jenkins_aws_secret_access_key_id: For Terraform provisioning
server-ssh-key: SSH access to EC2

✅ Result you end up with:

An app built and pushed to DockerHub
A fully provisioned EC2 instance
The app automatically deployed and accessible via the EC2 public IP on port 8080