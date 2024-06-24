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
        string(name: 'global_account_subdomain', defaultValue: 'hana-cloud-dev-cluster', description: 'subdomain of global account')
        string(name: 'cli_server_url', defaultValue: 'https://canary.cli.btp.int.sap', description: 'cli_server_url for this global account')

        string(name: 'subaccount_id', defaultValue: 'ddb78c82-1907-4b39-8b47-d5ee82971a4e', description: 'Input the subaccount id')
        string(name: 'admins', defaultValue: 'sample@email.com', description: '')
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
                        env.TF_VAR_subaccount_id=params.subaccount_id
                        env.TF_VAR_admin=params.admins

                        echo env.TF_VAR_cli_server_url
                        echo env.TF_VAR_global_account_subdomain
                        echo env.TF_VAR_admin

                        sh '''
                        terraform plan
                        '''
                    }
                }
            }
        }

        stage('Terraform apply'){
            steps {
                echo 'Terraform apply...'
                script {
                    sh '''
                    terraform apply
                    '''
                }
            }
        }
    }
}