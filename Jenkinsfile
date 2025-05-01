#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'https://github.com/TsembA/jenkins-shared-library.git',
   credentialsId: 'github-credentials']
)

pipeline {   
  agent any

  tools {
    maven 'maven'
  }

  environment {
    IMAGE_NAME = 'tsemb/demo-app:jma-6.0'
  }

  stages {

    stage("build app") {
      steps {
        script {
          echo 'Building application jar...'
          buildJar()
        }
      }
    }

    stage("build image") {
      steps {
        script {
          echo 'Building Docker image...'
          buildImage(env.IMAGE_NAME)
          dockerLogin()
          dockerPush(env.IMAGE_NAME)
        }
      }
    }

    stage("provision server") {
      steps {
        withCredentials([string(credentialsId: 'jenkins_aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
                         string(credentialsId: 'jenkins_aws_secret_access_key_id', variable: 'AWS_SECRET_ACCESS_KEY')]) {
          script {
            // Initialize and apply Terraform
            dir('terraform') {
              sh "terraform init"
              sh "terraform apply --auto-approve"
              EC2_PUBLIC_IP = sh(
                script: "terraform output ec2_public_ip",
                returnStdout: true
              ).trim()
            }
          }
        }
      }
    }

    stage("deploy") {
      environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
      }
      steps {
        script {
          echo 'Waiting for EC2 server to initialize...'
          sleep(time: 90, unit: "SECONDS")

          echo "Deploying Docker image to EC2 at ${EC2_PUBLIC_IP}..."

          def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
          def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

          sshagent(['server-ssh-key']) {
            sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
            sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
            sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
          }
        }
      }
    }

  }
}
