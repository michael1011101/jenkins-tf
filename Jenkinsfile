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
        string(name: 'admins', defaultValue: 'helle admins', description: 'What should I say?')
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
                        echo env.TF_VAR_clientsecret
                        echo env.TF_VAR_clientid
                        echo env.cli_server_url
                        echo params.admins
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