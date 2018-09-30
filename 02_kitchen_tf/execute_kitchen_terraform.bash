#! /usr/bin/env bash
bundle install

export AWS_REGION="eu-west-1"

# Destroy any existing Terraform state in us-east-1
bundle exec kitchen destroy aws

# Initialize the Terraform working directory and select a new Terraform workspace
# to test CentOS in us-east-1
bundle exec kitchen create aws

# Apply the Terraform root module to the Terraform state using the Terraform
# fixture configuration
bundle exec kitchen converge aws

# Test the Terraform state using the InSpec controls
bundle exec kitchen verify aws

# Destroy the Terraform state using the Terraform fixture configuration
bundle exec kitchen destroy aws

bundle exec kitchen test ubuntu --destroy