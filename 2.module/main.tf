module "task_vpc" {
  source = "./modules/task_vpc"

  # VPC configuration
  vpc_name            = "task-vpc"
  vpc_cidr_block      = "10.0.0.0/16"
  vpc_enable_dns_hostnames = true

  # Public subnet configuration
  public_subnet_name  = "public-subnet"
  public_subnet_cidr_block = "10.0.1.0/24"

  # Private subnet configuration
  private_subnet_name = "private-subnet"
  private_subnet_cidr_block = "10.0.2.0/24"

  # Cloud NAT configuration
  nat_name            = "task-nat"

}