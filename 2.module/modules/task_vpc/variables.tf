variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "public_subnet_name" {
  type = string
}

variable "public_subnet_cidr_block" {
  type = string
}

variable "public_subnet_az" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "private_subnet_cidr_block" {
  type = string
}

variable "private_subnet_az" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "nat_subnet_id" {
  type = string
}