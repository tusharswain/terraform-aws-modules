# Terraform AWS Modules

A collection of reusable Terraform modules for AWS infrastructure. This repository contains modular, production-ready Terraform configurations that can be easily integrated into your projects.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Available Modules](#available-modules)
- [Quick Start](#quick-start)
- [Module Structure](#module-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Resources](#resources)

## Prerequisites

Before using these modules, ensure you have the following installed:

### Required Tools

- **Terraform** (>= 1.0.0)
  - Download from: https://www.terraform.io/downloads
  - Verify installation: `terraform version`

- **AWS CLI** (>= 2.0.0)
  - Installation: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
  - Verify installation: `aws --version`

- **Git**
  - Download from: https://git-scm.com/downloads
  - Verify installation: `git --version`

### AWS Configuration

Configure your AWS credentials:
```bash
aws configure
```

You'll need:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., eu-north-1, us-east-1)
- Default output format (json)

### Optional Tools

- **Python** (>= 3.8) - For additional automation tools
  - See `requirements.txt` for Python dependencies

## Installation

1. Clone this repository:
```bash
git clone https://github.com/tusharswain/terraform-aws-modules.git
cd terraform-aws-modules
```

2. Install Python dependencies (optional):
```bash
pip install -r requirements.txt
```

## Available Modules

### EC2 Instances Module (`modules/ec2_instances`)

A reusable module for creating AWS EC2 instances with configurable parameters.

**Features:**
- Configurable AMI, instance type, and key pair
- Custom instance naming via tags
- Automatic SSH command generation
- Modular design for easy reuse

**Parameters:**
- `region` - AWS region where the instance will be created
- `ami` - AMI ID for the EC2 instance
- `instance_type` - EC2 instance type (e.g., t3.micro, t2.large)
- `key_name` - Name of the AWS key pair for SSH access
- `instance_name` - Name tag for the EC2 instance

### S3 Bucket Module (`modules/s3_bucket`)

A reusable module for creating AWS S3 buckets with security best practices.

**Features:**
- Configurable bucket name (must be globally unique)
- Versioning support
- Public access blocking
- Environment tagging
- Modular design for easy reuse

**Parameters:**
- `region` - AWS region where the bucket will be created
- `bucket_name` - Name of the S3 bucket (must be globally unique)
- `environment` - Environment tag for the bucket (default: dev)
- `versioning_enabled` - Enable versioning on the S3 bucket (default: true)
- `block_public_access` - Block all public access to the S3 bucket (default: true)

*More modules will be added in the future for other AWS resources.*

## Quick Start

### Using Multiple Modules

1. Create a new directory for your project:
```bash
mkdir my-terraform-project
cd my-terraform-project
```

2. Copy the modules:
```bash
cp -r /path/to/terraform-aws-modules/modules/ec2_instances ./modules/
cp -r /path/to/terraform-aws-modules/modules/s3_bucket ./modules/
```

3. Create your `main.tf`:
```hcl
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
```

4. Copy the example terraform file and add your values:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values:
```hcl
# EC2 Instance Variables
region        = "eu-north-1"
ami           = "ami-0aba19e56f3eaec05"
instance_type = "t3.micro"
key_name      = "my-key-pair"
instance_name = "My-Instance"

# S3 Bucket Variables
s3_bucket_name          = "my-unique-bucket-name-12345"
s3_environment          = "dev"
s3_versioning_enabled   = true
s3_block_public_access  = true
```

5. Initialize Terraform:
```bash
terraform init
```

6. Review the plan:
```bash
terraform plan
```

7. Apply the configuration:
```bash
terraform apply
```

## Module Structure

```
terraform-aws-modules/
├── modules/
│   ├── ec2_instances/
│   │   ├── main.tf           # Main resource configuration
│   │   ├── variables.tf      # Input variables
│   │   ├── outputs.tf        # Output values
│   │   └── terraform.tfvars # Default variable values
│   └── s3_bucket/
│       ├── main.tf           # Main resource configuration
│       ├── variables.tf      # Input variables
│       └── outputs.tf        # Output values
├── default/                  # Standard configuration (no workspaces)
│   ├── main.tf               # Example usage with variables
│   ├── backend.tf            # S3 backend configuration
│   ├── run_terraform.sh      # Helper script for Terraform commands
│   └── terraform.tfvars.example # Example variable values
├── workspace/                # Workspace-based configuration
│   ├── main.tf               # Example usage with workspace-aware instance types
│   ├── backend.tf            # S3 backend configuration
│   ├── run_terraform.sh      # Helper script for Terraform commands
│   └── terraform.tfvars.example # Example variable values
├── requirements.txt          # Python dependencies
├── .gitignore               # Git ignore rules
└── README.md                # This file
```

## Available Configurations

This repository provides two example configurations in separate directories because Terraform cannot have two `main.tf` files in the same folder.

### `default/` Directory

This is the standard configuration where you pass a single `instance_type` value directly. Use this when you do not need Terraform workspaces.

```bash
cd default
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform apply
```

### `workspace/` Directory

This configuration uses Terraform workspaces to select different `instance_type` values for `dev`, `stage`, and `prod` environments. The `instance_type` variable is a map and the active workspace decides which value is used.

```bash
cd workspace
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform workspace new dev
terraform workspace new stage
terraform workspace new prod
terraform workspace select dev
terraform apply
```

## Usage

### Using the Helper Script

A helper script `run_terraform.sh` is included in both `default/` and `workspace/` directories. Run it from the directory you want to use:

```bash
# For standard configuration
cd default
./run_terraform.sh apply

# For workspace-based configuration
cd workspace
./run_terraform.sh apply
```

### Targeting Specific Modules

If you want to create or update only a specific module without affecting others, you can use the `-target` flag:

```bash
# Create only the S3 bucket
terraform apply -target=module.s3_bucket

# Create only the EC2 instance
terraform apply -target=module.ec2_instance

# Destroy only the S3 bucket
terraform destroy -target=module.s3_bucket
```

**Note:** Using `-target` is not recommended for regular use as it can create inconsistent state. For better isolation, consider creating separate main.tf files or directories for different modules.

### Customizing Parameters

You can customize any parameter by editing the module call in your `main.tf`:

```hcl
module "ec2_instance" {
  source = "./modules/ec2_instances"

  region        = "us-east-1"        # Change region
  ami           = "ami-12345678"     # Use different AMI
  instance_type = "t2.large"         # Larger instance
  key_name      = "production-key"   # Different key pair
  instance_name = "Production-Web"  # Custom name
}
```

### Using Variables File

Alternatively, use a `.tfvars` file for your parameters:

Create `terraform.tfvars` like below:
```hcl
region        = "eu-north-1"
ami           = "ami-0aba19e56f3eaec05"
instance_type = "t3.micro"
key_name      = "my-key-pair"
instance_name = "My-Instance"
```

Then run:
```bash
terraform apply -var-file="terraform.tfvars"
```

## Contributing

Contributions are welcome! To add a new module:

1. Create a new directory under `modules/`
2. Add `main.tf`, `variables.tf`, and `outputs.tf`
3. Update this README with your module documentation
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Module Registry](https://registry.terraform.io/modules)
