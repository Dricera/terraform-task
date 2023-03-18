module "task_vpc" {
  source = "./modules/task_vpc"

  # VPC configuration
  vpc_name                 = "task-vpc"
  vpc_cidr_block           = "10.0.0.0/16"
  vpc_enable_dns_hostnames = true

  # Public Subnet configuration
  public_subnet_name       = "public-subnet"
  public_subnet_az         = "ap-southeast-1a"
  public_subnet_cidr_block = "10.0.1.0/24"

  # Private Subnet configuration
  private_subnet_name       = "private-subnet"
  private_subnet_az         = "ap-southeast-1a"
  private_subnet_cidr_block = "10.0.2.0/24"

  # Cloud NAT configuration
  nat_name = "task-nat"
  # Cloud NAT for private subnet
  nat_subnet_id = module.task_vpc.private_subnet_id
}

module "task_vm" {
  source = "./modules/task_vm"
  # VM configuration
  vpc_id = module.task_vpc.vpc_id
  private_subnet_id = module.task_vpc.private_subnet_id
  # Declared above two as variables to pass from module task_vpc output
  
  ami = "ami-07cd6551e6b101c99"
  instance_type = "t2.micro"
  key_name = "task-key"
   
}