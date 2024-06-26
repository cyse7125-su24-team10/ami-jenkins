#!/bin/bash
sudo apt-get upgrade -y
sudo apt-get update -y

# Install nginx
sudo apt-get install nginx -y
sudo systemctl status nginx

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

# Install Java
sudo apt-get update -y
sudo apt-get install fontconfig openjdk-17-jre -y
java -version

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

# Change nginx config and restart nginx to setup reverse proxy for jenkins
sudo mv /tmp/jenkins.conf /etc/nginx/conf.d/jenkins.conf
sudo systemctl daemon-reload
sudo systemctl restart nginx
sudo systemctl status nginx

# Install helm
sudo apt-get install -y wget \
    && wget https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz \
    && tar -zxvf helm-v3.7.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# Install nodejs
curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt-get install -y nodejs

# Install semantic-release plugins
sudo npm install -g semantic-release @semantic-release/commit-analyzer @semantic-release/release-notes-generator @semantic-release/changelog @semantic-release/github @semantic-release/git
sudo npm install semantic-release-helm

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install Let's Encrypt certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot


# Create initialization script for Jenkins
sudo mkdir -p /var/lib/jenkins/init.groovy.d/
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d/
sudo mv /tmp/basic-setup.groovy /var/lib/jenkins/init.groovy.d/basic-setup.groovy
sudo mv /tmp/git-credentials.groovy /var/lib/jenkins/init.groovy.d/git-credentials.groovy
sudo mv /tmp/docker-credentials.groovy /var/lib/jenkins/init.groovy.d/docker-credentials.groovy
sudo mv /tmp/casc.yaml /var/lib/jenkins/casc.yaml
sudo mv /tmp/webhook.groovy /usr/local/webhook.groovy
sudo mv /tmp/helm-cve-status-check.groovy /usr/local/helm-cve-status-check.groovy
sudo mv /tmp/helm-cve-release.groovy /usr/local/helm-cve-release.groovy
sudo mv /tmp/commit-lint-cve-processor.groovy /usr/local/commit-lint-cve-processor.groovy
sudo mv /tmp/commit-lint-helm-cve.groovy /usr/local/commit-lint-helm-cve.groovy
sudo mv /tmp/cve-processor-dbmigrate.groovy /usr/local/cve-processor-dbmigrate.groovy
sudo mv /tmp/cve-processor-docker.groovy /usr/local/cve-processor-docker.groovy
sudo mv /tmp/commit-lint-dbmigrate.groovy /usr/local/commit-lint-dbmigrate.groovy
sudo mv /tmp/infra-aws-status-check.groovy /usr/local/infra-aws-status-check.groovy
sudo mv /tmp/cve-consumer-docker.groovy /usr/local/cve-consumer-docker.groovy
sudo mv /tmp/helm-cve-consumer-release.groovy /usr/local/helm-cve-consumer-release.groovy
echo 'CASC_JENKINS_CONFIG="/var/lib/jenkins/casc.yaml"' | sudo tee -a /etc/environment
sudo sed -i 's/\(JAVA_OPTS=-Djava\.awt\.headless=true\)/\1 -Djenkins.install.runSetupWizard=false/' /lib/systemd/system/jenkins.service
sudo sed -i '/Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"/a Environment="CASC_JENKINS_CONFIG=/var/lib/jenkins/casc.yaml"' /lib/systemd/system/jenkins.service

# Restart Jenkins to apply changes
sudo systemctl daemon-reload
sudo systemctl restart jenkins
sudo journalctl -u jenkins --no-pager | tail -n 50


# Install docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl enable docker
sudo systemctl start docker

# add jenkins to docker users
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
