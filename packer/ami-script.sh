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

# Install Let's Encrypt certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Wait for Jenkins to start and initialize
#sleep 30

# Create initialization script for Jenkins
sudo mkdir -p /var/jenkins_home/casc_configs
sudo mv /tmp/setup-casc.yaml /var/jenkins_home/casc_configs/setup-casc.yaml
sudo chown -R jenkins:jenkins /var/jenkins_home/casc_configs
sudo chmod -R 755 /var/jenkins_home/casc_configs
sudo mkdir -p /var/lib/jenkins/init.groovy.d/
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d/
sudo mv /tmp/basic-setup.groovy /var/lib/jenkins/init.groovy.d/basic-setup.groovy
sudo systemctl restart jenkins
# Wait for script execution to finish
#sleep 30

# Restart Jenkins to apply changes
#sudo systemctl restart jenkins
sudo systemctl status jenkins
#sudo journalctl -u jenkins --no-pager | tail -n 50


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

# multiplatform image builder
sudo docker buildx create --use --name mybuilder




