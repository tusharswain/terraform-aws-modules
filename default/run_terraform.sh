#!/bin/bash

# Check if command argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {apply|destroy|plan}"
    echo "Example: $0 apply"
    exit 1
fi

command=$1

# Validate command
if [[ ! "$command" =~ ^(apply|destroy|plan)$ ]]; then
    echo "Error: Invalid command '$command'"
    echo "Valid commands: apply, destroy, plan"
    exit 1
fi

echo "=========================================="
echo "Terraform EC2 Instance Deployment"
echo "=========================================="
echo "Command: $command"
echo ""
echo "Current main.tf configuration:"
cat main.tf
echo ""
echo "=========================================="
echo "Running terraform $command..."
echo "=========================================="

terraform $command
