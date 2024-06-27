multibranchPipelineJob('commit-lint-helm-cve-consumer') {
    branchSources {
        github {
            id('9802390343484')
            repoOwner('cyse7125-su24-team10')
            repository('helm-webapp-cve-consumer')
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
            token("commit-lint-helm-cve-consumer")
        }
    }

    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile.commitlint')
        }
    }
}