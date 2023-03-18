# Tasks:
# 1. Create VPC
# 2. Create Public and Private Subnet
# 3. Deploy Cloud NAT and enable NAT for Private Subnet
# 3. Deploy VM on Private Subnet and check internet access
# 4. Go to VM in Private Subnet and retrieve NAT public IP

# 1. Create VPC
resource "aws_vpc" "task_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_enable_dns_hostnames = true
}

# 2. Create Public and Private Subnet

resource "aws_subnet" "task_public_subnet" {
vpc_id = "${aws_vpc.task_vpc.id}"
cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "task_private_subnet" {
vpc_id = "${aws_vpc.task_vpc.id}"
cidr_block = "10.0.2.0/24"
}
