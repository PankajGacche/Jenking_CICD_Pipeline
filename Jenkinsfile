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
                       sudo apt update && sudo apt install -y python3-pip'
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
        stage('Deploy to EC2') {
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
