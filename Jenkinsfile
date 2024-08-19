pipeline {
    agent any
   environment {
    ec2Host = 'ec2-16-171-253-111.eu-north-1.compute.amazonaws.com'
    SSH_KEY = credentials('my-ec2-key')
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
                        pip install --upgrade pip
                        pip install pytest  # Install pytest and any other dependencies
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
        stage('Deploy to EC2') {
            when {
                expression {
                    // Ensure the 'Test' stage was successful
                    currentBuild.currentResult == 'SUCCESS'
                }
            }
            steps {
                script {
                    sh '''
                        sudo chmod 400 $SSH_KEY
                        ssh -i $SSH_KEY ubuntu@$ec2Host "bash -s" < deploy-to-staging.sh
                        '''
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
