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
            emailext (
                subject: "Jenkins Build Succeeded: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: """
                    <html>
                    <body>
                        <p><b>This Jenkins build passed.</b></p>
                        <p><b>Job:</b> ${env.JOB_NAME}</p>
                        <p><b>Build Number:</b> ${env.BUILD_NUMBER}</p>
                        <p><b>Build URL:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    </body>
                    </html>
                """,
                to: 'pankajgacche.sdet@gmail.com',
                attachLog: true,
                compressLog: true,
                mimeType: 'text/html'
            )
        }
        
        failure {
            echo 'Pipeline failed.'
            emailext (
                subject: "Jenkins Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: """
                    <html>
                    <body>
                        <p><b>This Jenkins build failed.</b></p>
                        <p><b>Job:</b> ${env.JOB_NAME}</p>
                        <p><b>Build Number:</b> ${env.BUILD_NUMBER}</p>
                        <p><b>Build URL:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    </body>
                    </html>
                """,
                to: 'pankajgacche.sdet@gmail.com',
                attachLog: true,
                compressLog: true,
                mimeType: 'text/html'
            )
        }
        
        always {
            echo 'Pipeline finished.'
        }
    }
}
