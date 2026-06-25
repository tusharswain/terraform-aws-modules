terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the AWS key pair to use"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "s3_environment" {
  description = "Environment tag for the S3 bucket"
  type        = string
  default     = "dev"
}

variable "s3_versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_block_public_access" {
  description = "Block all public access to the S3 bucket"
  type        = bool
  default     = true
}

module "ec2_instance" {
  source = "./modules/ec2_instances"

  region        = var.region
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_name = var.instance_name
}

module "s3_bucket" {
  source = "./modules/s3_bucket"

  region               = var.region
  bucket_name          = var.s3_bucket_name
  environment          = var.s3_environment
  versioning_enabled   = var.s3_versioning_enabled
  block_public_access  = var.s3_block_public_access
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}

output "ec2_ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = module.ec2_instance.ssh_command
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_bucket.bucket_name
}