pipelineJob('webhook') {
    displayName('webhook')
    description('Job to poll on git scm')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team10/static-site.git')
                        credentials('github-pat')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile')
            }
        }
    }
    triggers{
        githubPush()
    }
}