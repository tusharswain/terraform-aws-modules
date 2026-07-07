# Important Terraform Commands

This document explains the most commonly used Terraform commands with examples and practical use cases.

## Core Commands

### `terraform init`

Initializes a Terraform working directory. It downloads the required providers and modules, configures the backend, and prepares the project for use.

```bash
terraform init
```

**Use case:** Run this first after cloning a project or after adding new providers/modules.

---

### `terraform plan`

Shows what changes Terraform will make to your infrastructure without actually applying them. It compares your configuration with the current state.

```bash
terraform plan
```

**Use case:** Review changes before applying them to avoid unexpected modifications or destruction.

---

### `terraform apply`

Executes the changes proposed by `terraform plan` and creates, updates, or destroys infrastructure.

```bash
terraform apply
```

**Use case:** Deploy your infrastructure after reviewing the plan.

```bash
terraform apply -auto-approve
```

**Use case:** Skip the interactive approval prompt (use with caution in production).

---

### `terraform destroy`

Destroys all resources managed by Terraform in the current workspace.

```bash
terraform destroy
```

**Use case:** Tear down a complete environment, such as a temporary dev environment.

```bash
terraform destroy -target=module.ec2_instance
```

**Use case:** Destroy only a specific module or resource.

---

## State Management Commands

### `terraform state list`

Lists all resources currently tracked in the Terraform state file.

```bash
terraform state list
```

**Use case:** Verify what resources Terraform knows about.

---

### `terraform state show`

Shows detailed information about a specific resource in the state file.

```bash
terraform state show aws_instance.this
```

**Use case:** Inspect the attributes of a specific resource.

---

### `terraform state rm`

Removes a resource from the Terraform state file without destroying the actual resource.

```bash
terraform state rm aws_instance.this
```

**Use case:** Stop managing a resource with Terraform while keeping it in AWS.

---

### `terraform import`

Imports an existing resource into Terraform state so that Terraform can manage it.

```bash
terraform import aws_instance.my_server i-0abcd1234567890ef
```

**Use case:** Bring manually created resources under Terraform management without recreating them.

**Important:** You must have a matching resource block in your Terraform code before importing.

---

### `terraform refresh`

Updates the Terraform state file to match the real-world infrastructure. It does not make any changes to the actual resources.

```bash
terraform refresh
```

**Use case:** Sync the state file with actual cloud resources after changes were made outside Terraform.

**Note:** Terraform 1.0+ introduced `terraform plan -refresh-only` as a safer alternative.

```bash
terraform plan -refresh-only
```

---

## Workspace Commands

### `terraform workspace new`

Creates a new Terraform workspace.

```bash
terraform workspace new dev
terraform workspace new prod
```

**Use case:** Separate state for different environments (dev, stage, prod).

---

### `terraform workspace select`

Switches to an existing workspace.

```bash
terraform workspace select prod
```

**Use case:** Work on a specific environment without affecting others.

---

### `terraform workspace list`

Lists all available workspaces and marks the current one.

```bash
terraform workspace list
```

---

### `terraform workspace show`

Shows the currently active workspace.

```bash
terraform workspace show
```

---

## Targeting and Variable Commands

### `terraform apply -target`

Applies changes only to a specific resource or module.

```bash
terraform apply -target=module.ec2_instance
terraform apply -target=module.s3_bucket
```

**Use case:** Deploy or update a single module without affecting others.

**Note:** Not recommended for regular use as it can leave the state in an inconsistent condition.

---

### `terraform apply -var-file`

Applies Terraform using a specific variable file.

```bash
terraform apply -var-file="terraform.tfvars"
```

**Use case:** Use custom variable files for different environments or teams.

---

### `terraform apply -var`

Passes a single variable value directly from the command line.

```bash
terraform apply -var="instance_name=My-Server"
```

**Use case:** Quickly override a variable without editing files.

---

## Output and Formatting Commands

### `terraform output`

Displays the values of defined outputs.

```bash
terraform output
terraform output instance_id
```

**Use case:** Retrieve useful information like IP addresses, IDs, or connection strings after deployment.

---

### `terraform fmt`

Automatically formats Terraform code according to standard style conventions.

```bash
terraform fmt
```

**Use case:** Keep code consistent and readable across the team.

---

### `terraform validate`

Validates the Terraform configuration files for syntax errors.

```bash
terraform validate
```

**Use case:** Catch errors before running `plan` or `apply`.

---

## Lock and Backend Commands

### `terraform force-unlock`

Releases a stuck state lock in the remote backend.

```bash
terraform force-unlock <LOCK_ID>
```

**Use case:** Recover from a failed Terraform run that left the state locked.

**Warning:** Use only when you are sure no other process is modifying the state.

---

### `terraform state pull`

Downloads the current state file from the remote backend and prints it.

```bash
terraform state pull
```

**Use case:** Inspect or back up the remote state file.

---

### `terraform state push`

Uploads a local state file to the remote backend.

```bash
terraform state push terraform.tfstate
```

**Use case:** Manually update remote state after a recovery or migration.

**Warning:** Be very careful with this command. It can overwrite the remote state.

---

## Taint and Replace Commands

### `terraform taint`

Marks a resource as tainted, forcing Terraform to recreate it on the next apply.

```bash
terraform taint aws_instance.this
```

**Use case:** Force replacement of a resource that Terraform thinks is healthy.

**Note:** In Terraform 0.15.2+, `terraform apply -replace` is preferred.

```bash
terraform apply -replace="aws_instance.this"
```

---

### `terraform untaint`

Removes the tainted mark from a resource.

```bash
terraform untaint aws_instance.this
```

**Use case:** Cancel a taint if you changed your mind.

---

## Quick Reference Table

| Command | Purpose |
|---------|---------|
| `terraform init` | Initialize project and download providers/modules |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy all resources |
| `terraform validate` | Validate configuration syntax |
| `terraform fmt` | Format code |
| `terraform output` | Show output values |
| `terraform refresh` | Sync state with real resources |
| `terraform import` | Import existing resources into state |
| `terraform state list` | List resources in state |
| `terraform state show` | Show details of a resource |
| `terraform state rm` | Remove resource from state without destroying it |
| `terraform workspace new` | Create a new workspace |
| `terraform workspace select` | Switch workspace |
| `terraform workspace list` | List workspaces |
| `terraform apply -target` | Apply only one resource/module |
| `terraform apply -var-file` | Use a specific variables file |
| `terraform force-unlock` | Release a stuck state lock |
| `terraform apply -replace` | Force recreation of a resource |

---

## What is HashiCorp Vault?

Vault is a secrets management tool created by HashiCorp. It is used to securely store, manage, and access sensitive information such as passwords, API keys, tokens, certificates, and database credentials.

### Why Use Vault?

- **Centralized Secrets Management**: Store all secrets in one secure location instead of scattering them in code, environment variables, or configuration files.
- **Dynamic Secrets**: Vault can generate temporary credentials on demand. For example, it can create a short-lived AWS access key or database username/password that automatically expires.
- **Encryption**: All secrets are encrypted at rest and in transit.
- **Access Control**: Vault uses policies to control who can access which secrets.
- **Audit Logging**: Vault logs every access to secrets, helping with security audits and compliance.
- **No Hardcoded Secrets**: Applications can request secrets from Vault at runtime instead of storing them in source code or Git.

### Common Use Cases

| Use Case | Example |
|----------|---------|
| Database credentials | Store MySQL/PostgreSQL passwords and rotate them automatically |
| API keys | Store AWS, Azure, or third-party API keys |
| TLS certificates | Manage SSL/TLS certificates |
| SSH keys | Store SSH private keys securely |
| Encryption keys | Manage encryption keys for applications |

### How Vault Works with Terraform

Terraform can read secrets from Vault using the Vault provider. This allows you to inject secrets into your Terraform configuration without storing them in plain text.

```hcl
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "vault" {
  address = "https://vault.example.com:8200"
}

data "vault_generic_secret" "db_password" {
  path = "secret/db"
}

resource "aws_db_instance" "example" {
  password = data.vault_generic_secret.db_password.data["password"]
}
```

**Benefits:**
- Secrets are not stored in `terraform.tfvars` or Git.
- Secrets can be rotated without changing Terraform code.
- Access to secrets is controlled and audited by Vault.

### Vault vs Terraform State File

| Feature | Terraform State | Vault |
|---------|-----------------|-------|
| Stores resource IDs | Yes | No |
| Stores secrets | Sometimes (avoid) | Yes |
| Encryption | Depends on backend | Always encrypted |
| Access control | Backend-dependent | Fine-grained policies |
| Dynamic secrets | No | Yes |
| Audit logging | Limited | Yes |

**Best practice:** Use Vault for secrets and use a remote backend (like S3) for state files. Never store sensitive values directly in Terraform state files if possible.
