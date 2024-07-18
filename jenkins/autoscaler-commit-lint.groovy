multibranchPipelineJob('autoscaler-commit-lint') {
    branchSources {
        github {
            id('90235544343')
            repoOwner('cyse7125-su24-team10')
            repository('helm-eks-autoscaler')
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
            token("autorelease-commitlint")
        }
    }

    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile.commitlint')
        }
    }
}