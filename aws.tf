provider "aws" {
  profile = ""
  region  = "ap-south-1"
}

# Provides EC2 key pair
resource "aws_key_pair" "terraformkey" {
  key_name   = "${var.name}_key"
  public_key = tls_private_key.k8s_ssh.public_key_openssh
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames=true
  enable_dns_support =true

  tags = {
    Name = "${var.name}citizen-K8S-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.k8s_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.name}citizen-Public-Subnet"
  }
}

resource "aws_internet_gateway" "k8s_gw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name = "${var.name}citizen-K8S-GW"
  }
}

resource "aws_route_table" "k8s_route" {
    vpc_id = aws_vpc.k8s_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s_gw.id
    }
        
        tags = {
            Name = "${var.name}citizen-K8S-Route"
        }
}

resource "aws_route_table_association" "k8s_asso" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.k8s_route.id
}

# Create security group
resource "aws_security_group" "allow_ssh_http" {
  name        = "${var.name}citizen-Web_SG"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.k8s_vpc.id

  ingress {
    description      = "Allow All"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  ingress {
    description      = "Allow All"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "K8S SG"
  }
}

resource "aws_instance" "k8s" {
#  ami                   = "ami-010aff33ed5991201"
  ami                   = "ami-00c7878b181453e4d"
  instance_type         = var.instance_type
  key_name	            = aws_key_pair.terraformkey.key_name
  associate_public_ip_address = true
  subnet_id             = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [ aws_security_group.allow_ssh_http.id ] 

  tags = {
    Name = "${var.name}-masternode"
  }
}



resource "aws_instance" "myk8svm" {
  count                 = var.worker_nodes
#  ami                   = "ami-010aff33ed5991201"
  ami                   = "ami-00c7878b181453e4d"
  instance_type         = var.instance_type
  key_name	            = aws_key_pair.terraformkey.key_name
  associate_public_ip_address = true
  subnet_id             = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [ aws_security_group.allow_ssh_http.id ] 

  tags = {
    Name = "${var.name}-workernode"
  }
}
