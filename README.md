## Terraform - AWS EC2 Instance Module [![Build Status](https://travis-ci.org/onaio/terraform-aws-ec2-instance.svg?branch=master)](https://travis-ci.org/onaio/terraform-aws-ec2-instance)

Use this module to create EC2 instances.

Check [variables.tf](./variables.tf) for a list of variables that can be set for this module.

## Usage

```yaml

module "ec2-instance" {
  source = "github.com/onaio/terraform-aws-ec2-instance"

  region                                = var.region
  env                                   = var.env
  vpc_id                                = var.vpc_id
  project                               = var.project
  project_id                            = var.project_id
  owner                                 = var.owner
  end_date                              = var.end_date
  ssh_key_name                          = var.ssh_key_name
  ssh_user                              = var.ssh_user
  deployed_app                          = var.deployed_app
  devops_client                         = var.devops_client
  server_monitoring_playbook            = var.server_monitoring_playbook
  server_count                          = var.server_count
  server_ami                            = var.server_ami
  server_instance_type                  = var.server_instance_type
  server_volume_size                    = var.server_volume_size
  associate_public_ip_address           = var.associate_public_ip_address
  delete_volume_on_instance_termination = var.delete_volume_on_instance_termination
  vault_password_file                   = var.vault_password_file
}
```
