resource "aws_instance" "bastion" {
  ami                     = var.ami
  disable_api_termination = var.ec2_setting.termination_protection
  iam_instance_profile    = aws_iam_instance_profile.bastion.name
  instance_type           = var.instance_type
  key_name                = aws_key_pair.bastion.key_name
  subnet_id               = var.subnet_ids[0]
  vpc_security_group_ids  = concat([aws_security_group.bastion.id], var.ec2_setting.additional_sg_ids)
  monitoring              = true
  user_data               = file("${path.module}/init.sh")

  maintenance_options {
    auto_recovery = "default"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.ec2_setting.root_volume_size
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name    = "${local.naming_prefix}-ec2-bastion"
    Service = "ec2"
  }

  volume_tags = {
    App     = "bastion"
    Name    = "${local.naming_prefix}-vol-bastion"
    Service = "ec2-volume"
  }

  depends_on = [
    aws_iam_instance_profile.bastion,
    aws_key_pair.bastion,
    aws_security_group.bastion
  ]
}

resource "aws_eip" "public_ip" {
  vpc = true

  tags = {
    App     = "bastion"
    Name    = "${local.naming_prefix}-eip-bastion"
    Service = "eip"
  }
}

resource "aws_eip_association" "server" {
  instance_id         = aws_instance.bastion.id
  allocation_id       = aws_eip.public_ip.id
  allow_reassociation = false

  depends_on = [
    aws_instance.bastion,
    aws_eip.public_ip
  ]
}

resource "aws_launch_template" "bastion" {
  name        = "${local.naming_prefix}-bastion"
  description = "For ${var.project} ${var.env} bastion server managed by Terraform"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = data.aws_kms_key.ebs.arn
      volume_size           = 8
      volume_type           = "gp2"
    }
  }

  disable_api_stop        = false
  disable_api_termination = false
  ebs_optimized           = true

  iam_instance_profile {
    arn = aws_iam_instance_profile.bastion.arn
  }

  image_id      = "ami-07200fa04af91f087"
  instance_type = "t3.micro"
  key_name      = "${local.naming_prefix}-bastion"

  maintenance_options {
    auto_recovery = "default"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.bastion.id,
    ]
  }

  private_dns_name_options {
    hostname_type                        = "ip-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = true
  }

  dynamic "tag_specifications" {
    for_each = local.tag_resources
    content {
      resource_type = tag_specifications.value

      tags = {
        App         = "bastion"
        Environment = var.env
        Service     = tag_specifications.value
        Project     = var.project
      }
    }
  }

  tags = {
    App     = "bastion"
    Service = "launch-template"
  }

  update_default_version = true
  user_data              = filebase64("${path.module}/init-ubuntu.sh")

  lifecycle {
    ignore_changes = [
      default_version,
    ]
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                    = "${local.naming_prefix}-bastion"
  default_instance_warmup = 120
  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
  desired_capacity          = 1
  force_delete              = false
  force_delete_warm_pool    = false
  max_size                  = 1
  min_size                  = 1
  wait_for_capacity_timeout = "5m"
  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Default"
  }

  vpc_zone_identifier = var.subnet_ids

  lifecycle {
    ignore_changes = [
      desired_capacity,
    ]
  }

  tag {
    key                 = "App"
    propagate_at_launch = true
    value               = "bastion"
  }
  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = var.env
  }
  tag {
    key                 = "Project"
    propagate_at_launch = true
    value               = var.project
  }
  tag {
    key                 = "Region"
    propagate_at_launch = true
    value               = var.region
  }
  tag {
    key                 = "Service"
    propagate_at_launch = true
    value               = "asg"
  }

  depends_on = [
    aws_launch_template.bastion
  ]
}
