##Terraform AWS provider
---
###Overview
- Install [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Use AWS secret keys from AWS Account Management Console
- `aws configure` to enter AWS access key and Secret access key
- `mkdir <project folder name>` Create a new project folder
- Create new file called main.tf

####Setup provider
- To use the AWS provider with Terraform. Replace my access/secret keys with newly created keys in AWS Management Console
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.36.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
    access_key = "my access key"
    secret_key = "my secret key"
}
```

###Resources
- `<resource type>.<resource name>`
Format of resource ids eg aws_instance.app_server

#####EC2

- Creating an EC2 instance. Make sure when entering the ami use one from the AWS launch instance Management console as the number may change over time
```
resource "aws_instance" "my-first-server" {
    ami           = "my ubuntu.id"
    instance_type = "t3.micro"

    tags = {
    Name = "HelloWorld"
    }
}
```

#####VPC, subnet

- Creating a VPC. Enter details for  resource name, cidr block, tag value
```
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "value"
  }
}
```

- Creating a subnet. Enter details for subnet name, vpc name, cidr block, tag value
```
resource "aws_subnet" "name" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "value"
  }
}
```
---
####References
- [Terraform Course - Automate your AWS cloud Infrastructure](https://www.youtube.com/watch?v=SLB_c_ayRMo)

- [Terraform providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)