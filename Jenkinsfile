pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ashrafmohddin/Terraform-Jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat '''
                    set AWS_ACCESS_KEY_ID=%aws-access-key-id%
                    set AWS_SECRET_ACCESS_KEY=%aws-secret-access-key%
                    set AWS_DEFAULT_REGION=%AWS_DEFAULT_REGION%
                    terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                bat '''
                    set AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID%
                    set AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY%
                    set AWS_DEFAULT_REGION=%AWS_DEFAULT_REGION%
                    terraform plan -out tfplan
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage('Apply or Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }
                        bat '''
                            set AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID%
                            set AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY%
                            set AWS_DEFAULT_REGION=%AWS_DEFAULT_REGION%
                            terraform apply -input=false tfplan
                        '''
                    } else if (params.action == 'destroy') {
                        bat '''
                            set AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID%
                            set AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY%
                            set AWS_DEFAULT_REGION=%AWS_DEFAULT_REGION%
                            terraform destroy --auto-approve
                        '''
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
    }
}
