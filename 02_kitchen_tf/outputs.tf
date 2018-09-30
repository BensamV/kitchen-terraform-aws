output "reachable_other_host_public_ip" {
  description = "The public IP address of the reachable_other_host instance"
  value       = "${aws_instance.reachable_other_host.public_ip}"
}

output "reachable_other_host_id" {
  description = "The public IP address of the reachable_other_host instance"
  value       = "${aws_instance.reachable_other_host.id}"
}

output "test_target_public_dns" {
  description = "The list of public DNS names assigned to the test_target instances"
  value       = ["${aws_instance.test_target.*.public_dns}"]
}

output "test_target_ids" {
  description = "The list of public DNS names assigned to the test_target instances"
  value       = ["${aws_instance.test_target.*.id}"]
}

output "security_group" {
  description = "The name of the security group"
  value       = "${aws_security_group.example.name}"
}

output "security_group_id" {
  description = "The name of the security group"
  value       = "${aws_security_group.example.id}"
}

output "vpc_id" {
  description = "The name of the security group"
  value       = "${data.aws_vpc.selected.id}"
}

output "subnet_id" {
  description = "The name of the security group"
  value       = "${aws_subnet.example.id}"
}

output "ami_id" {
  description = "The name of the security group"
  value       = "${aws_instance.reachable_other_host.ami}"
}