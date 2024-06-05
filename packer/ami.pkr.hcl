#Jenkins AMI
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
  type    = string
  default = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "ami_users" {
  type    = list(string)
  default = ["637423339703"]
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "nginx_config" {
  type    = string
  default = "./nginx/jenkins.conf"
}

variable "source_jenkins_job" {
  type    = string
  default = "./jenkins/basic-setup.groovy"
}

variable "source_git_job" {
  type    = string
  default = "./jenkins/git-credentials.groovy"
}

variable "source_docker_job" {
  type    = string
  default = "./jenkins/docker-credentials.groovy"
}

variable "source_webhook" {
  type    = string
  default = "./jenkins/webhook.groovy"
}

variable "admin_id" {
  type    = string
  default = ""
}

variable "admin_pwd" {
  type    = string
  default = ""
}

variable "GITHUB_USERNAME" {
  type    = string
  default = ""
}

variable "GITHUB_PAT" {
  type    = string
  default = ""
}

variable "GITHUB_PAT_ID" {
  type    = string
  default = ""
}

variable "GITHUB_PAT_DESC" {
  type    = string
  default = ""
}

variable "DOCKER_PAT" {
  type    = string
  default = ""
}

variable "DOCKER_PAT_ID" {
  type    = string
  default = ""
}

variable "DOCKER_PAT_DESC" {
  type    = string
  default = ""
}

source "amazon-ebs" "ami-jenkins" {
  region          = "${var.region}"
  ami_name        = "jenkins-ami-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  ami_description = "ami for jenkins instance"
  ami_users       = "${var.ami_users}"
  instance_type   = "${var.instance_type}"
  source_ami      = "${var.source_ami}"
  ssh_username    = "${var.ssh_username}"
}

build {
  sources = ["source.amazon-ebs.ami-jenkins"]
  provisioner "file" {
    source      = "${var.nginx_config}"
    destination = "/tmp/jenkins.conf"
  }
  provisioner "file" {
    source      = "${var.source_jenkins_job}"
    destination = "/tmp/basic-setup.groovy"
  }
  provisioner "file" {
    source      = "${var.source_git_job}"
    destination = "/tmp/git-credentials.groovy"
  }
  provisioner "file" {
    source      = "${var.source_docker_job}"
    destination = "/tmp/docker-credentials.groovy"
  }
  provisioner "file" {
    source      = "${var.source_webhook}"
    destination = "/tmp/webhook.groovy"
  }
  provisioner "shell" {
    inline = [
      "echo 'ADMIN_ID=${var.admin_id}' | sudo tee /etc/jenkins.env",
      "echo 'ADMIN_PWD=${var.admin_pwd}' | sudo tee -a /etc/jenkins.env",
      "echo 'GITHUB_USERNAME=${var.GITHUB_USERNAME}' | sudo tee -a /etc/jenkins.env",
      "echo 'GITHUB_PAT=${var.GITHUB_PAT}' | sudo tee -a /etc/jenkins.env",
      "echo 'GITHUB_PAT_ID=${var.GITHUB_PAT_ID}' | sudo tee -a /etc/jenkins.env",
      "echo 'GITHUB_PAT_DESC=${var.GITHUB_PAT_DESC}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKER_PAT=${var.DOCKER_PAT}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKER_PAT_ID=${var.DOCKER_PAT_ID}' | sudo tee -a /etc/jenkins.env",
      "echo 'DOCKER_PAT_DESC=${var.DOCKER_PAT_DESC}' | sudo tee -a /etc/jenkins.env"
    ]
  }
  provisioner "shell" {
    script = "packer/ami-script.sh"
  }
}