variable "key_name" {
  description = "The public key of the key pair"
  type        = "string"
}

variable "region" {
  description = "The geographic area in which the provider will place resources"
  type        = "string"
}

variable "subnet_availability_zone" {
  description = "The isolated, regional location in which to place the subnet"
  type        = "string"
}

variable "instance_ami" {
  description = "The ami to be used by the EC2 instances"
  type        = "string"
}

variable "instance_type" {
  description = "The instance type of the EC2 instances"
  type        = "string"
}

variable "instance_port" {
  description = "Port to be used for the http communication"
}