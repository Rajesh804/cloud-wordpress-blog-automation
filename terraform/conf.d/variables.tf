variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
    default = "wp-blog"
}

variable "USER_NAME" {
    description = "Username to be used in the names of created resources."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
    default = "/home/rreddy/Work/noon/wp-blog.pem"
}

variable "subnet_id" {
    description = "Which subnet id to create this in?"
    default = "subnet-1593cd70"
}
variable "vpc_id" {
    description = "Which vpc id to create this in?"
    default = "vpc-9feaa3fa"
}

variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "SERVER_SIZE" {}
variable "NUM_SERVERS" {}
variable "APP_NAME" {}
variable "ENV_NAME" {}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-west-2"
}

# Ubuntu Server 14.04 LTS (x64)
variable "aws_amis" {
    description = "Image to be used in instance creation"
    default = "ami-19fa4f79" 
	}

