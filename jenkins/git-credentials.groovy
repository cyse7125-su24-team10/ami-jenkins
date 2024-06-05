import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import java.util.Properties


def props = new Properties()
def envFile = new File('/etc/jenkins.env')
if (envFile.exists()) {
    props.load(envFile.newDataInputStream())
} else {
    throw new RuntimeException("/etc/jenkins.env file not found")
}

// Parameters
def username = props.getProperty('GITHUB_USERNAME')
def password = props.getProperty('GITHUB_PAT')
def credentialId = props.getProperty('GITHUB_PAT_ID')
def description = props.getProperty('GITHUB_PAT_DESC')

// Get the Jenkins instance
def jenkinsInstance = Jenkins.getInstance()

// Get the global domain
def domain = Domain.global()

// Create the credentials
def credentials = new UsernamePasswordCredentialsImpl(
        CredentialsScope.GLOBAL,
        credentialId,
        description,
        username,
        password
)

// Add the credentials to the global domain
def credentialsStore = jenkinsInstance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentialsStore.addCredentials(domain, credentials)

println "Credentials added successfully with ID: ${credentialId}"
