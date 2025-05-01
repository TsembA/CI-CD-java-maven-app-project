# Define input variables
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
    default = "10.0.0.0/24"
}
variable "avail_zone" {
    default = "us-west-1"
}
variable "env_prefix" {
    default = "dev"
}
variable "jenkins_ip" {
    default = "64.23.232.108/32"
  
}
variable "my_ip" {
    default = "76.32.237.136/32"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "region" {
    default = "us-west-1"
}
variable "avail_zone" {
    default = "us-west-1b"
  
}