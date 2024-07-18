multibranchPipelineJob('autoscaler-release') {
    branchSources {
        github {
            id('980239344')
            repoOwner('cyse7125-su24-team10')
            repository('helm-eks-autoscaler')
            buildForkPRHead(false)
            buildForkPRMerge(true)
            buildOriginBranchWithPR(false)
            buildOriginBranch(true)
            scanCredentialsId('github-pat')
            checkoutCredentialsId('github-pat')
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile')
        }
    }
}