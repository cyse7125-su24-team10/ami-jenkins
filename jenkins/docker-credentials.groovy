import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import org.jenkinsci.plugins.plaincredentials.impl.*
import hudson.util.Secret
import java.util.Properties


def props = new Properties()
def envFile = new File('/etc/jenkins.env')
if (envFile.exists()) {
    props.load(envFile.newDataInputStream())
} else {
    throw new RuntimeException("/etc/jenkins.env file not found")
}

// Parameters
def secretText = props.getProperty('DOCKER_PAT')
def credentialId = props.getProperty('DOCKER_PAT_ID')
def description = props.getProperty('DOCKER_PAT_DESC')

// Get the Jenkins instance
def jenkinsInstance = Jenkins.getInstance()

// Get the global domain
def domain = Domain.global()

// Create the credentials
def credentials = new StringCredentialsImpl(
        CredentialsScope.GLOBAL,
        credentialId,
        description,
        Secret.fromString(secretText)
)

// Add the credentials to the global domain
def credentialsStore = jenkinsInstance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentialsStore.addCredentials(domain, credentials)

println "Text credentials added successfully with ID: ${credentialId}"
