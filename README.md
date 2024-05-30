# ami-jenkins
CI/CD Infrastructure using jenkins

[![Packer](https://img.shields.io/badge/Packer-02A8EF.svg?style=for-the-badge&logo=Packer&logoColor=white)](https://www.packer.io/)  [![NGINX](https://img.shields.io/badge/NGINX-009639.svg?style=for-the-badge&logo=NGINX&logoColor=white)](https://www.nginx.com/)  [![HashiCorp](https://img.shields.io/badge/HashiCorp-000000.svg?style=for-the-badge&logo=HashiCorp&logoColor=white)](https://www.hashicorp.com/) [![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF.svg?style=for-the-badge&logo=GitHub-Actions&logoColor=white)](https://github.com/features/actions) [![Let's Encrypt](https://img.shields.io/badge/Let's%20Encrypt-003A70.svg?style=for-the-badge&logo=Let's-Encrypt&logoColor=white)](https://letsencrypt.org/) [![Jenkins](https://img.shields.io/badge/Jenkins-D24939.svg?style=for-the-badge&logo=Jenkins&logoColor=white)](https://www.jenkins.io/)


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
