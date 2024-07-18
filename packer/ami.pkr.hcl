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

variable "commit_lint_cve" {
  type    = string
  default = "./jenkins/commit-lint-cve-processor.groovy"
}

variable "commit_lint_cve_helm" {
  type    = string
  default = "./jenkins/commit-lint-helm-cve.groovy"
}

variable "cve_processor_dbmigrate" {
  type    = string
  default = "./jenkins/cve-processor-dbmigrate.groovy"
}

variable "cve_processor_docker" {
  type    = string
  default = "./jenkins/cve-processor-docker.groovy"
}

variable "cve_consumer_docker" {
  type    = string
  default = "./jenkins/cve-consumer-docker.groovy"
}

variable "helm_cve_consumer" {
  type    = string
  default = "./jenkins/helm-cve-consumer-release.groovy"
}

variable "commit_lint_cve_helm_consumer" {
  type    = string
  default = "./jenkins/commit-lint-helm-consumer.groovy"
}

variable "commit_lint_cve_consumer" {
  type    = string
  default = "./jenkins/commit-lint-cve-consumer.groovy"
}

variable "autoscaler_release" {
  type    = string
  default = "./jenkins/autoscaler-release.groovy"
}

variable "source_casc" {
  type    = string
  default = "./jenkins/casc.yaml"
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

variable "source_helm_cve_status_check" {
  type    = string
  default = "./jenkins/helm-cve-status-check.groovy"
}

variable "source_helm_cve_release" {
  type    = string
  default = "./jenkins/helm-cve-release.groovy"
}
variable "commit_lint_dbmigrate" {
  type    = string
  default = "./jenkins/commit-lint-dbmigrate.groovy"
}

variable "source_infra_aws_status_check" {
  type    = string
  default = "./jenkins/infra-aws-status-check.groovy"
}

variable "autoscaler_commitlint" {
  type    = string
  default = "./jenkins/autoscaler-commit-lint.groovy"
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
  provisioner "file" {
    source      = "${var.source_casc}"
    destination = "/tmp/casc.yaml"
  }
  provisioner "file" {
    source      = "${var.source_helm_cve_status_check}"
    destination = "/tmp/helm-cve-status-check.groovy"
  }
  provisioner "file" {
    source      = "${var.source_helm_cve_release}"
    destination = "/tmp/helm-cve-release.groovy"
  }
  provisioner "file" {
    source      = "${var.commit_lint_cve}"
    destination = "/tmp/commit-lint-cve-processor.groovy"
  }

  provisioner "file" {
    source      = "${var.commit_lint_cve_helm}"
    destination = "/tmp/commit-lint-helm-cve.groovy"
  }

  provisioner "file" {
    source      = "${var.cve_processor_dbmigrate}"
    destination = "/tmp/cve-processor-dbmigrate.groovy"
  }

  provisioner "file" {
    source      = "${var.cve_processor_docker}"
    destination = "/tmp/cve-processor-docker.groovy"
  }

  provisioner "file" {
    source      = "${var.cve_consumer_docker}"
    destination = "/tmp/cve-consumer-docker.groovy"
  }

  provisioner "file" {
    source      = "${var.helm_cve_consumer}"
    destination = "/tmp/helm-cve-consumer-release.groovy"
  }

  provisioner "file" {
    source      = "${var.commit_lint_dbmigrate}"
    destination = "/tmp/commit-lint-dbmigrate.groovy"
  }

  provisioner "file" {
    source      = "${var.source_infra_aws_status_check}"
    destination = "/tmp/infra-aws-status-check.groovy"
  }

  provisioner "file" {
    source      = "${var.commit_lint_cve_helm_consumer}"
    destination = "/tmp/commit-lint-helm-consumer.groovy"
  }

  provisioner "file" {
    source      = "${var.commit_lint_cve_consumer}"
    destination = "/tmp/commit-lint-cve-consumer.groovy"

  }
  provisioner "file" {
    source      = "${var.autoscaler_release}"
    destination = "/tmp/autoscaler-release.groovy"
  }

  provisioner "file" {
    source      = "${var.autoscaler_commitlint}"
    destination = "/tmp/autoscaler-commit-lint.groovy"
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