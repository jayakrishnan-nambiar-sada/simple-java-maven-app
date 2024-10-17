pipeline {
    agent any
    tools {
        maven "maven-tool"
    }
    options {
        skipStagesAfterUnstable()
    }
    environment {
        commitSha = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        dockerImageTag = "jayakrishnanm/my-app:${commitSha}"
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Deliver') { 
            steps {
                sh './jenkins/scripts/deliver.sh' 
            }
        }
        stage('Build docker image ') {
            steps {
                script{
                    sh 'docker --version'
                    sh 'docker build -t ' + dockerImageTag + ' .'
                }
            }
        }
        stage('Push image to Docker') {
            steps{
                withCredentials([string(credentialsId: 'dockerhub-pat', variable: 'PASSWORD')]) {
                    sh 'docker login -u jayakrishnanm -p $PASSWORD'
                    sh 'docker push ' + dockerImageTag    
                }
            }
        }
    }
}