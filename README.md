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

*More modules will be added in the future for other AWS resources.*

## Quick Start

### Using the EC2 Instances Module

1. Create a new directory for your project:
```bash
mkdir my-terraform-project
cd my-terraform-project
```

2. Copy the module:
```bash
cp -r /path/to/terraform-aws-modules/modules/ec2_instances ./modules/
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

module "ec2_instance" {
  source = "./modules/ec2_instances"

  region        = var.region
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_name = var.instance_name
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = module.ec2_instance.ssh_command
}
```

4. Copy the example terraform file and add your values:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values:
```hcl
region        = "eu-north-1"
ami           = "ami-0aba19e56f3eaec05"
instance_type = "t3.micro"
key_name      = "my-key-pair"
instance_name = "My-Instance"
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
│   └── ec2_instances/
│       ├── main.tf           # Main resource configuration
│       ├── variables.tf      # Input variables
│       ├── outputs.tf        # Output values
│       └── terraform.tfvars # Default variable values
├── main.tf                   # Example usage with variables
├── terraform.tfvars.example  # Example variable values (copy this to terraform.tfvars)
├── terraform.tfvars          # Your actual values (gitignored - not committed)
├── run_terraform.sh          # Helper script for Terraform commands
├── requirements.txt          # Python dependencies
├── .gitignore               # Git ignore rules
└── README.md                # This file
```

## Usage

### Using the Helper Script

A helper script `run_terraform.sh` is provided for convenience:

```bash
# Apply infrastructure
./run_terraform.sh apply

# Destroy infrastructure
./run_terraform.sh destroy

# View plan
./run_terraform.sh plan
```

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
