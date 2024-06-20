multibranchPipelineJob('infra-aws-status-check') {
    branchSources {
        github {
            id('98022339084')
            repoOwner('cyse7125-su24-team10')
            repository('infra-aws')
            buildForkPRHead(true)
            buildForkPRMerge(false)
            buildOriginBranchWithPR(false)
            buildOriginBranch(false)
            scanCredentialsId('github-pat')
            checkoutCredentialsId('github-pat')
        }
    }
    configure { node ->
        def webhookTrigger = node / triggers / 'com.igalg.jenkins.plugins.mswt.trigger.ComputedFolderWebHookTrigger' {
            spec('')
            token("infra-aws-status-check")
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile')
        }
    }
}