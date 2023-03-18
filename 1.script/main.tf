# Tasks:
# 1. Create VPC
# 2. Create Public and Private Subnet
# 3. Deploy Cloud NAT and enable NAT for Private Subnet
# 3. Deploy VM on Private Subnet and check internet access
# 4. Go to VM in Private Subnet and retrieve NAT public IP

# 1. Create VPC
resource "aws_vpc" "task_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# 2. Create Public and Private Subnet

resource "aws_subnet" "task_public_subnet" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "task_private_subnet" {
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = "10.0.2.0/24"
}

# 3. Deploy Cloud NAT and enable NAT for Private Subnet

#3.0 Elastic IP for NAT Gateway
resource "aws_eip" "task_nat_eip" {
  vpc = true
}

# 3.1. Create internet gateway for VPC
resource "aws_internet_gateway" "task_igw" {
  vpc_id = aws_vpc.task_vpc.id
}

# 3.2. Route tables for public subnet
resource "aws_route_table" "task_public_route_table" {
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task_igw.id # Internet Gateway
  }
}

# 3.3. Associate route table to public subnet
resource "aws_route_table_association" "task_public_route_table_association" {
  subnet_id      = aws_subnet.task_public_subnet.id
  route_table_id = aws_route_table.task_public_route_table.id
}

# 3.4 Route tables for private subnet
resource "aws_route_table" "task_private_route_table" {
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.task_nat_gateway.id # NAT Gateway
  }
}

# 3.5 Associate route table for private subnet to use NAT gateway
resource "aws_route_table_association" "task_private_route_table_association" {
  subnet_id      = aws_subnet.task_private_subnet.id
  route_table_id = aws_route_table.task_private_route_table.id
}

# 3.6 Cloud NAT Gateway
resource "aws_nat_gateway" "task_nat_gateway" {
  allocation_id = aws_eip.task_nat_eip.id # NAT EIP
  subnet_id     = aws_subnet.task_public_subnet.id
  depends_on = [
    aws_internet_gateway.task_igw
  ]
}


#3.7  Enable NAT for Private Subnet
resource "aws_route" "task_private_route" {
  route_table_id         = aws_route_table.task_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.task_nat_gateway.id
}



# 4. Deploy VM on Private Subnet and check internet access

# 4.1. Security group for inbound SSH
resource "aws_security_group" "task_sg" {
  name        = "task_sg"
  description = "Allow limited traffic"
  vpc_id      = aws_vpc.task_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4.2. Deploy VM on Private Subnet
resource "aws_instance" "task_vm" {
  ami                    = "ami-07cd6551e6b101c99" # Ubuntu 18.04
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.task_private_subnet.id
  vpc_security_group_ids = [aws_security_group.task_sg.id]
  key_name               = "task_key"
  tags = {
    Name = "task_vm"
  }


  # 4.3 Check internet access in VM

  provisioner "remote-exec" {
    inline = [
      "if ping -q -c 1 -W 1 google.com >/dev/null; then echo \"Internet not available\"; else  echo \"Internet available\"; fi"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("task_key.pem") #/path/to/key
      host        = aws_instance.task_vm.public_ip
    }
  }
}



# 5. Go to VM in Private Subnet and retrieve NAT public IP

resource "null_resource" "task_get_publicIP" {
  provisioner "remote-exec" {
    inline = [
      "curl -s checkip.amazonaws.com" #Return public IP
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("task_key.pem") #/path/to/key
      host        = aws_instance.task_vm.public_ip
    }
  }
}