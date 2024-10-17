pipeline {
    agent any
    tools {
        maven "maven-tool"
        docker "docker-tool"
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
                sh 'docker --version'
                sh 'docker build -t gcr.io/playground-s-11-1982ae45/my-app:latest .'
            }
        }
    }
}