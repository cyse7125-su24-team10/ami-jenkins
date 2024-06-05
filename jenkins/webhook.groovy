import jenkins.model.Jenkins

def jobName = "web-hook"
def instance = Jenkins.getInstance()
def job = instance.getItem(jobName)

if (job == null) {
    def jobConfig = """
<flow-definition plugin="workflow-job@1400.v7fd111b_ec82f">
  <actions>
    <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobAction plugin="pipeline-model-definition@2.2198.v41dd8ef6dd56"/>
    <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction plugin="pipeline-model-definition@2.2198.v41dd8ef6dd56">
      <jobProperties/>
      <triggers/>
      <parameters/>
      <options/>
    </org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction>
  </actions>
  <description>A Jenkins pipeline job created via Groovy script.</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers>
        <com.cloudbees.jenkins.GitHubPushTrigger plugin="github@1.39.0">
          <spec/>
        </com.cloudbees.jenkins.GitHubPushTrigger>
      </triggers>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@3894.3896.vca_2c931e7935">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@5.2.2">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/vk-NEU7/githubhook.git</url>
          <credentialsId>github-pat</credentialsId>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
"""
    def xmlStream = new ByteArrayInputStream(jobConfig.getBytes("UTF-8"))
    def jobDefinition = instance.createProjectFromXML(jobName, xmlStream)
    println "Created job '${jobName}'"
} else {
    println "Job '${jobName}' already exists"
}
