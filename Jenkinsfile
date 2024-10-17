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
        PROJECT_ID = 'playground-s-11-d11d6293'
        CLUSTER_NAME = 'jenkins-gke'
        LOCATION = 'us-central1-a'
        CREDENTIALS_ID = 'jenkins-gke'
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
                    sh 'docker build -t jayakrishnanm/my-app:v1 .'
                }
            }
        }
        stage('Push image to Docker') {
            steps{
                withCredentials([string(credentialsId: 'dockerhub-pat', variable: 'PASSWORD')]) {
                    sh 'docker login -u jayakrishnanm -p $PASSWORD'
                    sh 'docker push jayakrishnanm/my-app:v1 '  
                }
            }
        }
        stage('Deploy to GKE') {
            steps{
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'petclinic.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
		        echo "Deployment Finished ..."
            }
        }
    }
}