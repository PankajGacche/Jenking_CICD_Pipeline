pipeline {
    agent any
    environment {
        SSH_KEY_ID = 'ec2-ssh-key' // Replace with the ID of your SSH key credential
    }
    stages {
        stage('Build') {
            steps {
                // Checkout source code
                checkout scm

                // Set up and activate virtual environment
                script {
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install -r requirements.txt
                    '''
                }
            }
        }
        stage('Test') {
            steps {
                // Activate virtual environment and run tests
                script {
                    sh '''
                        . venv/bin/activate
                        pytest
                    '''
                }
            }
        }
        stage('Deploy') {
            when {
                // Only deploy if the tests pass
                expression {
                    return currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                // Deploy application to staging environment
                script {
                    sh 'deploy-to-staging.sh'
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            echo 'Pipeline finished.'
        }
    }
}
