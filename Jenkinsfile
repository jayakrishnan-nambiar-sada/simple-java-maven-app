pipeline {
    agent any
    tools {
        maven "maven-tool"
    }
    options {
        skipStagesAfterUnstable()
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
        stage('Build docker image') {
            steps {
                script{
                    sh 'docker --version'
                    def commitSha = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    def dockerImageTag = "gcr.io/playground-s-11-1982ae45/my-app:${commitSha}"
                    sh 'docker build -t ' + dockerImageTag + ' .'
                //  sh 'docker build -t gcr.io/playground-s-11-1982ae45/my-app:latest .'
                }
            }
        }
    }
}