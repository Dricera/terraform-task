resource "aws_security_group" "task_sg" {
  name        = "task_sg"
  description = "Allow limited traffic"
  vpc_id      = var.vpc_id

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

resource "aws_instance" "task_vm" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.task_sg.id]
  key_name = var.key_name
  tags = {
	Name = var.vm_name
  }

 provisioner "remote-exec" {
    inline = [
      "if ping -q -c 1 -W 1 google.com >/dev/null; then echo \"Internet not available\"; else  echo \"Internet available\"; fi"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem") #/path/to/key
      host        = aws_instance.task_vm.public_ip
    }
  }
}

resource "null_resource" "task_get_publicIP" {
  provisioner "remote-exec" {
    inline = [
      "curl -s checkip.amazonaws.com" #Return public IP
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem") #/path/to/key
      host        = aws_instance.task_vm.public_ip
    }
  }
}