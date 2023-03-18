variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vm_name" {
  type = string
  default = "task-vm"
}

variable "vpc_id" {
	type = string
}

variable "private_subnet_id" {
	type = string
}