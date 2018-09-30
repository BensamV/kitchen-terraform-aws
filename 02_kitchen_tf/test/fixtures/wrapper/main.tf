module "extensive_kitchen_terraform" {
    source = "../../../"
    key_name = "${var.key_name}"
    region = "${var.region}"
    subnet_availability_zone = "${var.subnet_availability_zone}"
    instance_ami = "${var.instance_ami}"
    instance_type = "${var.instance_type}"
    instance_port = "${var.instance_port}"
}