##Terraform basics
With AWS Cloud Infrastructure

---

####Install
######Mac OS
Using [Homebrew](brew.sh) in terminal install hashicorp homebrew packages using
`brew tap hashicorp/tap`
Then install terraform
`brew install terraform`

- `terraform -v`
In cmd prompt to show what version terraform is installed

####Folders/Files

Terraform is a declarative manner, meaning that we are defining with Terraform what the final infrastructure is to look like at the end, not steps to carry out. Eg: a blueprint of final infrastructure. Terraform will figure out what needs to be deployed, remain the same or deleted


- `main.tf`
Terraform files end in .tf

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
Downloads necessary plugins depending on the configuration in the .tf file. Run this for first time before plan

- `terraform plan`
Strongly recommended to run this before apply, shows the actions that Terraform will take

- `terraform apply`
Shows changes/actions Terraform will take, confirm deploying code with 'yes'

- `terraform apply -target <resource_type.resource_name>`
To restart a single specified resource, confirm deploying resource with 'yes'

- `terraform output`
Gives outputs of current state. If a new output is entered, run terraform refresh

- `terraform refresh`
Refreshes state without applying changes, gives outputs

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

- `terraform destroy -target <resource_type.resource_name>`
Destroys a single specified resource. Name example "aws_instance.web-server-instance"








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





####Variables
- creates a variable that can be used. To use variable in code `var.<variable_name>` If default is not predefined, terminal will prompt to define it when terraform apply has been run
```
variable "name" {
  description = 
  default =
  type =
}
```

- `terraform apply -var "<variable_name>=<value>"`
Using command line to set the variable and apply at the same time

- Creating a variable list, use `terraform.tfvars` and list the variables used in the following format  variable_name = value. The value can be a list, to refer to it in code `var.variable_name[0]`

-  To use a different variable file name use `terraform apply -var-file <file_name>

- Handling variables as objects in the terraform.tfvars file
`<variable_name> = [{<resource_parameter> = value, name = value}, {etc}] `
In code refer to the variable object as `var.<variable_name>[object_name].<resource_parameter>`







####References
- [Terraform Course - Automate your AWS cloud Infrastructure](https://www.youtube.com/watch?v=SLB_c_ayRMo)

- [Terraform providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)