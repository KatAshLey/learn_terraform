##Terraform basics
With AWS Cloud Infrastructure

---


Terraform is a declarative manner, meaning that we are defining with Terraform what the final infrastructure is to look like at the end, not steps to carry out. Eg: a blueprint of final infrastructure. Terraform will figure out what needs to be deployed, remain the same or deleted

- `terraform -v`
in cmd prompt to show what version terraform is installed

- `main.tf`
Terraform files end in .tf

*Folders/Files*
- *.terraform* folder is automatically created when terraform init command is run, containing the configuration files needed

- *terraform.tfstate* file provides what the current status of the latest deployment is. Used to compare differences to new plan/apply. DO NOT CHANGE, WILL BREAK






####Terraform overview
- `terraform`
In command line will give you the available commands

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

- `terraform init`
downloads necessary plugins depending on the configuration in the .tf file. Run this for first time before plan

- `terraform plan`
strongly recommended to run this before apply, shows the actions that Terraform will take

- `terraform apply`
shows changes/actions Terraform will take, confirm running code with 'yes'

- `terraform output`
gives outputs of current state. If a new output is entered, run terraform refresh

- `terraform refresh`
refreshes state without applying changes, gives outputs

- `--auto-approve`
Adding this to the end of a command that needs approval eg Yes to continue, will remove the approval step

- convert PEM file to ppk using putty gem, to use in putty in order to SSH into instances. For user name enter ubuntu@ipaddress

- `terraform state`
To list available commands for state checking

- `terraform state list`
Shows a list of resources created that have a state

- `terraform state show <resource name from list>`
Shows details of resource named

- `terraform destroy`
Deletes all resources using command line. Shows changes that will happen. Enter yes to confirm delete. 
To remove one resource, you can comment out the code as it is declarative model, then terraform apply it will update with deleting the single resource







####Resources

- Set up resources base syntax. To find resource type use Terraform providers link in References and search for resource in left menu
```
resource "<provider>_<resource_type>" "name" {
    config options in the following format
    key = value
}
```

- Tags can be created to easily search and categorize resources. Uses key and value which can be defined by the user. Enter this in the resource block
```
resource .... {
    ......
    tags = {
    key = "value"
    }
}
```

- Outputs printed out when using terraform apply. Must do one for each output needed
```
output "name" {
    value = <resource.resource_name.property_name>
}

output "server_public_ip" {
    value = aws_eip.one.public_ip
}
```






######EC2

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






######VPC, subnet

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





####References
- [Terraform Course - Automate your AWS cloud Infrastructure](https://www.youtube.com/watch?v=SLB_c_ayRMo)

- [Terraform providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)