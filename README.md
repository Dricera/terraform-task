# terraform-task
A Terraform workload that completes 5 tasks:
 * Create a VPC/VNET 
 * Create one Private Subnet & Public Subnet  
 * Deploy Cloud NAT and enable NATing for Private subnet 
 * Deploy Virtual machine on Private Subnet and check the internet access 
 * Go to VM in Private Subnet and Check what is my IP, it should display NAT Public IP 

It uses the AWS provider as a service provider base.
