terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.36.0"
        }
    }
}

# Configure the AWS Provider, must use access keys from AWS management console
provider "aws" {
    region = "us-east-1"
    access_key = "my access key"
    secret_key = "my secret key"
}

/*
references

# EC2 created, ami needs id from AWS
resource "aws_instance" "my-first-server" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
}

# VPC created
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
    Name = "learning"
    }
}

# Subnet created
resource "aws_subnet" "subnet-01" {
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
    Name = "learning"
    }
} 
*/


variable "subnet_prefix" {
    description = "cidr block for the subnet"
    #default
    #type
}


# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Prod"
    }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.prod-vpc.id
}

# 3. Create Custom Route Table
resource "aws_route_table" "prod-route-table" {
    vpc_id = aws_vpc.prod-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "Prod"
    }
}

# 4. Create a Subnet
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = var.subnet_prefix[0].cidr_block
    availability_zone = "us-east-1a"

    tags = {
        Name = var.subnet_prefix[0].name
    }
}

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = var.subnet_prefix[1].cidr_block
    availability_zone = "us-east-1a"

    tags = {
        Name = var.subnet_prefix[1].name
    }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 22, 80, 443
resource "aws_security_group" "allow_web" {
    name        = "allow_web_traffic"
    description = "Allow Web inbound traffic"
    vpc_id      = aws_vpc.prod-vpc.id

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 433
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name = "allow_web"
    }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
    subnet_id       = aws_subnet.subnet-1.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.allow_web.id]
}

# 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
    domain                    = "vpc"
    network_interface         = aws_network_interface.web-server-nic.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [aws_internet_gateway.gw]
    }

# prints output after terraform apply is called
output "server_public_ip" {
    value = aws_eip.one.public_ip
}

# 9. Create Ubuntu server and install/enable apache 2

resource "aws_instance" "web-server-instance" {
    ami = "..." #ami from aws management console
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "main-key"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index/html'
                EOF

    tags = {
        Name = "web-server"
    }
}



