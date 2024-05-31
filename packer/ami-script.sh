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
sleep 120

# Create initialization script for Jenkins
sudo mkdir -p /var/lib/jenkins/init.groovy.d/
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d/
sudo tee /var/lib/jenkins/init.groovy.d/basic-setup.groovy << 'EOF'
#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.install.*

// Get the Jenkins instance
def instance = Jenkins.getInstance()

// Set up Jenkins security realm and authorization strategy
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin', 'admin')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// Set the Jenkins installation state to RUNNING to skip the setup wizard
def state = instance.getInstallState()
if (state != InstallState.RUNNING) {
    //InstallState.initializeState()
    //InstallState.RUNNING.initializeState()
    InstallState.INITIAL_SETUP_COMPLETED.initializeState()
}

// Install Plugins
def plugins = ["git", "workflow-aggregator","pipeline-utility-steps","github","github-api"]
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()

plugins.each {
  if (!pm.getPlugin(it)) {
    def plugin = uc.getPlugin(it)
    plugin.deploy()
  }
}

// Create a "Hello World" job
def jobName = "hello-world"
def job = instance.getItem(jobName)
if (job == null) {
  def jobConfig = """
<flow-definition plugin="workflow-job">
  <actions/>
  <description>A simple hello world job.</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps">
    <script>echo 'Hello, World!'</script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
"""
  def xmlStream = new ByteArrayInputStream(jobConfig.getBytes("UTF-8"))
  def jobDefinition = jenkins.model.Jenkins.getInstance().createProjectFromXML(jobName, xmlStream)
  println "Created job '${jobName}'"
} else {
  println "Job '${jobName}' already exists"
}

instance.save()
EOF


sudo systemctl restart jenkins


# Wait for script execution to finish
sleep 60

# Restart Jenkins to apply changes
sudo systemctl restart jenkins
sudo systemctl status jenkins
sudo journalctl -u jenkins --no-pager | tail -n 50
