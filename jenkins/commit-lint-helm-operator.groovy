multibranchPipelineJob('commit-lint-helm-cve-operator') {
    branchSources {
        github {
            id('9802838388984')
            repoOwner('cyse7125-su24-team10')
            repository('helm-cve-operator')
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
            token("commit-lint-helm-cve-operator")
        }
    }

    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile.commitlint')
        }
    }
}