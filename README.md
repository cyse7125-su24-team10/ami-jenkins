# ami-jenkins
CI/CD Infrastructure using jenkins

# Jenkins AMI with Packer

This project contains a Packer configuration for building an Amazon Machine Image (AMI) tailored for Jenkins with an Nginx configuration. The configuration uses the amazon-ebs builder to create the AMI and provisions it with the necessary software and configurations. Nginx is used as a reverse proxy for Jenkins.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Packer](https://www.packer.io/) version 1.2.8 or higher
- AWS account with the necessary IAM permissions setup at organization level for github actions

### Usage

To build the AMI, follow these steps:

1. Clone the repository and navigate to the directory:

    ```sh
    git clone git@github.com:cyse7125-su24-team10/ami-jenkins.git
    cd ami-jenkins
    ```
2. Intialize packer

    ```sh
    packer init ./packer/
    ```

3. Validate the Packer template:

    ```sh
    packer validate ./packer/
    ```

3. Build the AMI:

    ```sh
    packer build ./packer/
    ```
