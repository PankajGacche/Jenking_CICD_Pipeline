pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Checkout source code
                checkout scm

                // Install dependencies using pip
                script {
                    sh 'pip3 install -r requirements.txt'
                }
            }
        }
        stage('Test') {
            steps {
                // Run unit tests using pytest
                script {
                    sh 'pytest'
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
                    // Replace with your deployment script or commands
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
