resource "aws_instance" "ec2-instance" {
  count         = var.server_count
  ami           = var.server_ami
  instance_type = var.server_instance_type
  key_name      = var.ssh_key_name
  subnet_id     = length(var.instance_subnet_id) > 0 ? var.instance_subnet_id : element(tolist(data.aws_subnets.all.ids), count.index)
  # "distinct" seems to prevent change-detection of new vpc_security_group_ids
  vpc_security_group_ids      = distinct(concat(data.aws_security_group.default.*.id, aws_security_group.sg.*.id, var.vpc_security_group_ids))
  private_ip                  = length(var.private_ips) > 0 ? element(var.private_ips, count.index) : var.private_ip
  associate_public_ip_address = var.associate_public_ip_address
  availability_zone           = var.instance_availability_zone
  user_data                   = var.user_data
  ebs_optimized               = var.ebs_optimized
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.server_volume_size
    delete_on_termination = var.delete_volume_on_instance_termination
  }

  tags = {
    Name            = length(var.instance_name_tag) > 0 ? var.instance_name_tag : "${var.project}-${var.deployed_app}-${var.env}"
    Group           = length(var.instance_group_tag) > 0 ? var.instance_group_tag : "${var.project}-${var.env}"
    OwnerList       = var.owner
    EnvironmentList = var.env
    EndDate         = var.end_date
    ProjectList     = var.project_id
    DeploymentType  = var.deployment_type
  }

  volume_tags = {
    Name            = length(var.instance_name_tag) > 0 ? var.instance_name_tag : "${var.project}-${var.deployed_app}-${var.env}"
    Group           = "${var.project}-${var.env}"
    OwnerList       = var.owner
    EnvironmentList = var.env
    EndDate         = var.end_date
    ProjectList     = var.project_id
    DeploymentType  = var.deployment_type
  }
}

resource "null_resource" "server-setup" {
  count      = var.run_server_setup ? length(aws_instance.ec2-instance) : 0
  depends_on = [aws_instance.ec2-instance]

  connection {
    user = var.ssh_user
    host = aws_instance.ec2-instance[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = ["ls"]

    connection {
      type = "ssh"
      user = var.ssh_user
    }
  }

  provisioner "local-exec" {
    command = "sleep 30 && cd ${var.playbooks_root_dir} && ansible-playbook -i ansible/inventories/${var.devops_client}/${var.env} ${var.server_monitoring_playbook} -e ansible_host=${aws_instance.ec2-instance[count.index].public_ip} -e ansible_ssh_user=ubuntu -e ssh_local_user=$USER -e server_monitoring_set_hostname=true -e hostname_from_ec2_Name_tag=false -e server_monitoring_hostname=${var.project_id}-${var.deployed_app}-${var.env} -e server_monitoring_hostname_from_ec2_Name_tag=False --vault-password-file ${var.vault_password_file} --limit ${aws_instance.ec2-instance[count.index][var.playbooks_inventory_type]}"
  }
}

resource "null_resource" "post-create-commands" {
  count      = var.run_post_setup_remote_commands ? length(aws_instance.ec2-instance) : 0
  depends_on = [aws_instance.ec2-instance]

  connection {
    user = var.ssh_user
    host = aws_instance.ec2-instance[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = var.post_setup_remote_commands

    connection {
      type = "ssh"
      user = var.ssh_user
    }
  }
}
