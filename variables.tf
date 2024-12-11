variable "region" {
  description = "The region to deploy the instance to"
  default     = "eu-west-1" # Ireland
}

variable "storage_class" {
  description = "Storage class"
  default     = "gp2"
}

variable "env" {
  description = "The deployment environment this instance belongs to. Possible values: stage, preview, production"
  default     = "stage"
}

variable "vpc_id" {
  description = "The VPC to place the instance in. Ensure it is in the same region you want the instance in"
}

variable "project" {
  description = "Project name this instance belongs to"
}

variable "project_id" {
  description = "Project billing ID this instance belongs to. This is used to track billing"
}

variable "deployment_type" {
  type        = string
  default     = "vm"
  description = "The deployment type the resources brought up by this module are part of."
}

variable "owner" {
  description = "The project billing owner ID this instance belongs to"
}

variable "end_date" {
  description = "The project expected end date"
}

variable "ssh_key_name" {
  description = "The name of the preconfigured ssh key pair to add to the instance"
  default     = "devops"
}

variable "ssh_user" {
  description = "SSH user to use to login into the instance"
  default     = "ubuntu"
}

variable "deployed_app" {
  description = "Name of the app to be deployed to this instance"
}

variable "devops_client" {
  description = "Devops client name. This is a friendly name used in defining ansible inventories"
}

variable "server_monitoring_playbook" {
  description = "The server setup playbook file name. This is the first playbook used to setup basic monitoring and authentication"
  default     = "server-setup.yml"
}

variable "server_count" {
  description = "Number of insntances to deploy"
  default     = 1
}

variable "server_ami" {
  description = "The AMI to use. Note AMIs are specific to a region "
  default     = "ami-08d658f84a6d84a80"
}

variable "server_instance_type" {
  description = "The EC2 instance type to use"
  default     = "t3.micro"
}

variable "server_volume_size" {
  description = "The size of the EBS volume to attach to the instance, in GBs"
  default     = 8
}

variable "associate_public_ip_address" {
  description = "Whether to asssociate a public IP address to this instance"
  default     = true
}

variable "delete_volume_on_instance_termination" {
  description = "Whether to delete the attached volume when the instance is terminated"
  default     = true
}

variable "vault_password_file" {
  description = "Path to the ansible-vault password file"
  default     = "~/ona/.vault_pass.txt"
}

variable "vpc_security_group_ids" {
  description = "Security groups to attach to the instance"
  type        = list(any)
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "private_ips" {
  description = "A list of private IP address to associate with the instance in a VPC. Should match the number of instances."
  type        = list(any)
  default     = []
}

variable "public_ip" {
  description = "Public IP address to assign to the instance"
  type        = string
  default     = null
}

variable "public_ips" {
  description = "A list of public IP addresses to assign to the instances. Should match the number of instances."
  type        = list(any)
  default     = []
}

variable "assign_elastic_ip" {
  description = "Should we use an elastic IP with the instance?"
  default     = false
}

variable "allow_eip_reassociation" {
  description = "Whether to allow an Elastic IP to be re-associated"
  type        = bool
  default     = false
}

variable "instance_subnet_id" {
  description = "The subnet ID to start the instance in"
  default     = ""
}

variable "instance_availability_zone" {
  description = "The availability zone to start the instance in"
  default     = ""
}

variable "instance_name_tag" {
  description = "The instance name"
  default     = ""
}

variable "instance_group_tag" {
  description = "The instance group tag"
  default     = ""
}

variable "run_server_setup" {
  description = "Should we run the server setup playbook"
  default     = true
}

variable "run_post_setup_remote_commands" {
  type        = bool
  default     = false
  description = "Wether to run what is in post_setup_remote_commands"
}

variable "post_setup_remote_commands" {
  type        = list(string)
  default     = []
  description = "A list of commands to run on the EC2 instance after it becomes available"
}

variable "use_default_aws_security_group" {
  type        = bool
  default     = false
  description = "Whether to use the default aws security group named 'default'"
}

variable "create_security_group" {
  default     = false
  description = "Whether to create an aws security group"
  type        = bool
}

variable "security_group_rules" {
  default     = []
  description = "List of AWS security_group_rules to apply"
  type = list(object({
    type        = string
    to_port     = string
    from_port   = string
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "playbooks_root_dir" {
  type        = string
  default     = "../../../../"
  description = "The relative path to the directory containing the playbooks to be run"
}

variable "playbooks_inventory_type" {
  type    = string
  default = "public_ip"
}

variable "user_data" {
  type        = string
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument."
  default     = ""
}

variable "ebs_optimized" {
  type        = bool
  default     = false
  description = "An Amazon EBS–optimized instance uses an optimized configuration stack and provides additional, dedicated capacity for Amazon EBS I/O"
}

variable "iam_instance_profile" {
  type        = string
  default     = null
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. Ensure your credentials have the correct permission to assign the instance profile according to the EC2 documentation, notably iam:PassRole."
}
