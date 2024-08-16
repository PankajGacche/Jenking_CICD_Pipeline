pipeline{
  agent any
  stages{
    stage('Checkout'){
      steps{
        checkout scmGit(branches: [[name: '/*main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/PankajGacche/Jenking_CICD_Pipeline.git']])
      }
    }
    stage('Build'){
      steps{
        git branch: 'main', url: 'https://github.com/PankajGacche/Jenking_CICD_Pipeline.git'
        bat 'python simple_app.py'
      }
      stage('Test'){
        steps{
          echo "Flask application is running."
      }
        stage('Test'){
        steps{
          echo "Flask application deplyed successfully."
      }  
    }
  }
}
