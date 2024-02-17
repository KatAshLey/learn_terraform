##Install Terraform
---
#####Mac OS
- Using [Homebrew](brew.sh) in terminal install hashicorp homebrew packages using
`brew tap hashicorp/tap`
- To install terraform
`brew install terraform`

#####Mac OS - manual, also works for most Linux
- Download appropriate Terraform package from [Terraform.io](www.terraform.io/downloads.html)
- In command window unzip file
`ls terraform_filename`
`unzip terraform_filename`
- To find out your path
 `echo $PATH`
- To move unzipped file to path
`mv ~/Downloads/terraform /ust/local/bin/`

#####Windows - Chocolatey
- Install [Chocolately](chocolatey.org/install) package manager
- Launch Powershell in Administrator mode
`choco install terraform`
Confirm with 'y'

#####Windows - manual
- Download appropriate Terraform package from [Terraform.io](www.terraform.io/downloads.html)
- Unzip file and install in C:\terraform
- Open environment variables, select path, edit, add C:\terraform

#####Linux - Fedora, RedHat Enterprise Linux or Amazon Linux
- `cat /etc/fedora-release`
- Choose one that relates to your system
`export release=RHEL`
`export release=Amazon Linux`
`export release=fedora`
- install dif config manager to manage repositories
`sudo dnf install -y dnf-plugins-core`
- Install Hashicorp Linus repository
`sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo`
- Install terraform from the repo
`sudo dnf -y install terraform`

#####Linux - Debian, Ubuntu
- Download Hashicorp's GPG with curl,then install with apt key
`curl -fsSL https://apt.release.hashicorp.com/gpg sudo apt-key add - OK`
- Install Hashicorp GPG key
`wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg`
- Verify key's fingerprint
`gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint`
- Add Hashicorp repo
`echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list`
- Download package information
`sudo apt update`
- Install terraform
`sudo apt-get install terraform`





###Verify install/Version
- `terraform -help`
Verify install of terraform using Powershell or command window

- `terraform -v`
In cmd prompt to show what version terraform is installed

###Install Docker
Provision an NGINUX server with Docker
#####Mac
- Download [Docker Desktop](https://docs.docker.com/docker-for-mac/install/)
- `open -a Docker`
- Create directory
`mkdir learn-terraform-docker-container`

#####Windows
- Download and install [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- Download [Docker](https://docs.docker.com/docker-for-windows/install)
- While Docker application is open, create a directory
`mkdir learn-terraform-docker-container`

#####Linux
- Install [Docker](https://docs.docker.com/engine/install/)
- Create directory
`mkdir learn-terraform-docker-container`


#####All operating systems
- Navigate to working directory
`cd learn-terraform-docker-container`
- Create a new file called `main.tf` and paste following code

#####Mac Linux
```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
```

#####Windows
```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
```

#####All operating systems
Use init, apply, visit in web browser http://localhost:8000/, run `docker ps` to see container, destroy

---
####References

- [Terraform Hashicorp tutorials](https://developer.hashicorp.com/terraform/tutorials?product_intent=terraform)