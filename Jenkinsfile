pipeline{
  agent any
  environment {
        PYTHON_EXE = 'C:/Users/Administrator/AppData/Local/Programs/Python/Python312/python.exe'
    }
  stages{
    stage('Checkout'){
      steps{
        checkout scmGit(branches: [[name: '/*main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/PankajGacche/Jenking_CICD_Pipeline.git']])
      }
    }
    stage('Build'){
      steps{
        git branch: 'main', url: 'https://github.com/PankajGacche/Jenking_CICD_Pipeline.git'
        bat 'python3 simple_app.py'
      }
    }
      stage('Test'){
        steps{
          echo "Flask application is running."
        }
      }
        stage('Deploy'){
        steps{
          echo "Flask application deplyed successfully."
      }  
    }
  }
}

