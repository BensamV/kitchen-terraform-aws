provider "aws" {
  region     = "${var.region}"
}

//Create a new VPC or use your exisiting one
//VPC cidr - 192.168.0.0/20
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Terraform Demo VPC"]
  }
}

resource "aws_subnet" "example" {
  availability_zone       = "${var.subnet_availability_zone}"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "true"
  vpc_id                  = "${data.aws_vpc.selected.id}"

  tags {
    Name = "kitchen_terraform_example"
  }
}

//Create a new Internet gateway or use your existing one
data "aws_internet_gateway" "gw"{
  tags {
    Name = "terratest_ig"
  }
}

/*resource "aws_internet_gateway" "example" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Name = "kitchen_terraform_example"
  }
}*/

resource "aws_route_table" "example" {
  vpc_id = "${data.aws_vpc.selected.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "kitchen_terraform_example"
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = "${aws_subnet.example.id}"
  route_table_id = "${aws_route_table.example.id}"
}

resource "aws_security_group" "example" {
  description = "Allow all inbound traffic"
  name        = "kitchen-terraform-example-sg"
  vpc_id      = "${data.aws_vpc.selected.id}"

  egress {
    cidr_blocks = [
      "0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port = "${var.instance_port}"
    to_port   = "${var.instance_port}"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "kitchen-terraform-example"
    Terraform = "true"
  }
}

# These aws_instances will be targeted with the operating_system control and the
# reachable_other_host control

resource "aws_instance" "test_target" {
  ami                    = "${var.instance_ami}"
  count                  = 2
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.example.id}"
  vpc_security_group_ids = [
    "${aws_security_group.example.id}"]

  tags {
    Name      = "kitchen-terraform-test-target-${count.index}"
    Terraform = "true"
  }
}

# The reachable_other_host control will attempt to connect to this aws_instance
# from each of the test_target aws_instances which will verify the configuration
# of the associated aws_security_group

resource "aws_instance" "reachable_other_host" {
  ami                         = "${var.instance_ami}"
  associate_public_ip_address = true
  instance_type               = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids      = [
    "${aws_security_group.example.id}"]
  subnet_id                   = "${aws_subnet.example.id}"

  user_data                   = "${data.template_file.user_data.rendered}"
  tags {
    Name      = "kitchen-terraform-reachable-other-host"
    Terraform = "true"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data/user-data.sh")}"

  vars {
    instance_port = "${var.instance_port}"
  }
}

resource "null_resource" "before" {
  depends_on = ["aws_instance.test_target","aws_instance.reachable_other_host"]
}

//Providing a delay, so that all resources are created
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
