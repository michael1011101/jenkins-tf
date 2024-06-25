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
        string(name: 'global_account_subdomain', defaultValue: 'hana-cloud-dev-cluster', description: 'Input subdomain of global account')
        string(name: 'cli_server_url', defaultValue: 'https://canary.cli.btp.int.sap', description: 'Input cli_server_url for this global account')

        string(name: 'subaccount_id', defaultValue: 'ddb78c82-1907-4b39-8b47-d5ee82971a4e', description: 'Input the guid of subaccount')
        string(name: 'role_collection_names', defaultValue: '["Subaccount Viewer"]', description: 'Input the role collection formated as list')
        string(name: 'admins', defaultValue: '["sample@email.com", "sample2@email.com"]', description: 'Input the email list formated as ["1@email.com", "2@email.com]')
        booleanParam(name: 'auto_approved', defaultValue: false, description: 'Flag to auto approve for terraform apply')
    }

    stages {
        stage('Clean up workspace') {
            steps {
                cleanWs()
            }
        }

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
                        env.TF_VAR_global_account_subdomain=params.global_account_subdomain
                        env.TF_VAR_cli_server_url=params.cli_server_url
                        env.TF_VAR_subaccount_id=params.subaccount_id
                        env.TF_VAR_role_collection_names=params.role_collection_names
                        env.TF_VAR_admins=params.admins

                        echo env.TF_VAR_cli_server_url
                        echo env.TF_VAR_global_account_subdomain
                        echo env.TF_VAR_admins

                        sh '''
                        terraform plan
                        '''
                    }
                }
            }
        }

        stage('Terraform apply'){
            when {
                beforeAgent true
                expression { return params.auto_approved }
            }

            steps {
                echo 'Terraform apply...'
                withCredentials([usernamePassword(credentialsId: 'btpProviderCreds', passwordVariable: 'TF_VAR_global_account_password', usernameVariable: 'TF_VAR_global_account_username')]) {
                    script {
                        sh '''
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }
}