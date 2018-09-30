provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "example" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_ec2.id}"]
}

resource "aws_security_group" "sg_ec2" {
  name = "terratest_ec2_sg"

  # To keep this example simple, we allow incoming HTTP requests from my IP. In real-world usage, you may want to
  # lock this down to just the IPs of trusted servers (e.g., of a load balancer).
  ingress {
    from_port = "${var.instance_port}"
    to_port   = "${var.instance_port}"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //replace with your IP
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //replace with your IP
  }

}

resource "null_resource" "before" {
  depends_on = ["aws_instance.example","aws_security_group.sg_ec2"]
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 240"
  }
  triggers = {
    "before" = "${null_resource.before.id}"
  }
}

resource "null_resource" "after" {
  depends_on = ["null_resource.delay"]
}
