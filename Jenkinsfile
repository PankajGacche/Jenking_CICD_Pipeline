pipeline {
    agent any
   environment {
    SSH_KEY_PATH = '/var/lib/jenkins/My_Key_Pair.pem'
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
        stage('Set Permissions') {
            steps {
                // Ensure the script has execute permissions
                sh 'chmod +x deploy-to-staging.sh'
            }
        }
        stage('Deploy') {
            when {
            expression {
               return currentBuild.result == null || currentBuild.result == 'SUCCESS'
            }
            }
            steps {
                // Deploy application to staging environment
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: SSH_KEY_ID, keyFileVariable: 'SSH_KEY')]) {
                        sh './deploy-to-staging.sh'
                    }
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
