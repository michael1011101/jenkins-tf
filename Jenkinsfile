#!groovy

pipeline {
    agent any

    environment {
        global_account_subdomain='<abc>'
        cli_server_url='<abc-cli>'
        global_account_username='gau'
        global_account_password='gap'
    }

    parameters {
        string(name: 'global_account_subdomain', defaultValue: 'hello subdomain', description: 'subdomain of global account')
        string(name: 'cli_server_url', defaultValue: 'https://cli.btp.cloud.sap', description: 'cli_server_url for this global account')

        string(name: 'admins', defaultValue: 'helle admins', description: 'What should I say?')
        text(name: 'DEPLOY_TEXT', defaultValue: 'One\nTwo\nThree\n', description: '')
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    echo 'Terraform Init...'
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan'){
            steps {
                echo 'Terraform apply...'
                withCredentials([usernamePassword(credentialsId: 'btpProviderCreds', passwordVariable: 'TF_VAR_global_account_password', usernameVariable: 'TF_VAR_global_account_username')]) {
                    script {
                        echo env.TF_VAR_global_account_password
                        echo env.TF_VAR_global_account_username
                        env.TF_VAR_global_account_subdomain=params.global_account_subdomain
                        env.TF_VAR_cli_server_url=params.cli_server_url
                        echo env.TF_VAR_cli_server_url
                        echo env.TF_VAR_global_account_subdomain
                        echo params.admins
                        echo params.DEPLOY_TEXT
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