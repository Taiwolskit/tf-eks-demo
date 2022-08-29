output "instance_id" {
  value = aws_instance.bastion.id
}

output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "iam_role_id" {
  value = aws_iam_role.bastion.id
}

output "sg_id" {
  value = aws_security_group.bastion.id
}

output "ssh_key" {
  sensitive = true
  value = {
    fingerprint = aws_key_pair.bastion.fingerprint
    key_name    = aws_key_pair.bastion.key_name
    key_pair_id = aws_key_pair.bastion.key_pair_id
    key_type    = aws_key_pair.bastion.key_type
  }
}
