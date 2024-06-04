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

variable "source_jenkins_plugins" {
  type    = string
  default = "./jenkins/plugins.txt"
}

variable "source_jenkins_casc" {
  type    = string
  default = "./jenkins/setup-casc.yaml"
}

variable "source_jenkins_job" {
  type    = string
  default = "./jenkins/basic-setup.groovy"
}

variable "admin_id" {
  type    = string
  default = ""
}

variable "admin_pwd" {
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
    source      = "${var.source_jenkins_plugins}"
    destination = "/tmp/plugins.txt"
  }
  provisioner "file" {
    source      = "${var.source_jenkins_casc}"
    destination = "/tmp/setup-casc.yaml"
  }
  provisioner "file" {
    source      = "${var.source_jenkins_job}"
    destination = "/tmp/basic-setup.groovy"
  }
  provisioner "shell" {
    inline = [
      "echo 'ADMIN_ID=${var.admin_id}' | sudo tee /etc/jenkins.env",
      "echo 'ADMIN_PWD=${var.admin_pwd}' | sudo tee -a /etc/jenkins.env"
    ]
  }
  provisioner "shell" {
    script = "packer/ami-script.sh"
  }
}