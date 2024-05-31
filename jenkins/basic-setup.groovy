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