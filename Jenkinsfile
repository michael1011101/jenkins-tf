#!groovy

pipeline {
    agent {
        node {
            label 'docker-agent-tf'
        }
    }

    environment {
        global_account_subdomain='<abc>'
        cli_server_url='<abc-cli>'
        global_account_username='gau'
        global_account_password='gap'
    }

    stages {
        stage('Terraform Init') {
            steps {
                docker pull hashicorp/terraform:light
                echo 'Terraform Init..'
                echo '${pwd}'
                sh 'pwd'
                docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform:light init
            }
        }

        stage('Terraform Plan'){
            steps {
                echo 'Terraform apply...'
                withCredentials([usernamePassword(credentialsId: 'btpProviderCreds', passwordVariable: 'TF_VAR_clientsecret', usernameVariable: 'TF_VAR_clientid')]) {
                    script {
                        echo env.TF_VAR_clientsecret
                        echo env.TF_VAR_clientid
                        echo env.cli_server_url
                        docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform:light plan
                    }
                }
            }
        }

        stage('Terraform apply'){
            steps {
                echo 'Terraform apply...'
            }
        }
    }
}