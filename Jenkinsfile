#!groovy

pipeline {
    agent any

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
                sh '''
                FILE=terraform.tfstate
                DIR=.terraform

                # Check if file exists
                if [ -f "$FILE" ]; then
                    echo "$FILE exists. Deleting now."
                    rm terraform.tfstate*
                else 
                    echo "$FILE does not exist."
                fi

                # Check if directory exists
                if [ -d "$DIR" ]; then
                    echo "$DIR exists. Deleting now."
                    rm -r .terraform*
                else
                    echo "$DIR does not exist."
                fi
                '''

                notifyBuild("STARTED")
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

    post {
        // only triggered when blue or green sign
        success {
            notifyBuild("SUCCESSFUL")
        }
        // triggered when red sign
        failure {
            notifyBuild("FAILED")
        }
    }
}

def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful
    buildStatus =  buildStatus ?: 'SUCCESSFUL'

    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"

    // Override default values based on build status
    if (buildStatus == 'STARTED') {
        color = 'YELLOW'
        colorCode = '#FFFF00'
    } else if (buildStatus == 'SUCCESSFUL') {
        color = 'GREEN'
        colorCode = '#00FF00'
    } else {
        color = 'RED'
        colorCode = '#FF0000'
    }

    // Send notifications
    slackSend (color: colorCode, message: summary)
}
