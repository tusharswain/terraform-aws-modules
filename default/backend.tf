# This is the backend configuration for Terraform
terraform {
  backend "s3" {
    bucket         = "my-unique-example-bucket-trs" # change this
    key            = "trswain/default/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    use_lockfile   = true
  }
}