multibranchPipelineJob('commit-lint-db-cve-processor') {
    branchSources {
        github {
            id('980235548884')
            repoOwner('cyse7125-su24-team10')
            repository('db-cve-processor')
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
            token("db-cve-processor-commitlint")
        }
    }

    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile.commitlint')
        }
    }
}