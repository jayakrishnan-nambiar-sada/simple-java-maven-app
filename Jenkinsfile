pipeline {
    agent any
    tools {
        maven "maven-tool"
    }
    options {
        skipStagesAfterUnstable()
    }
    environment {
        dockerImageTag = "jayakrishnanm/my-app:${env.BUILD_ID}"
        PROJECT_ID = 'playground-s-11-57ae4e23'
        CLUSTER_NAME = 'jenkins-gke'
        LOCATION = 'us-central1-a'
        CREDENTIALS_ID = 'playground-key'
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
                    sh "docker build -t ${dockerImageTag} ."
                }
            }
        }
        stage('Push image to Docker') {
            steps{
                withCredentials([string(credentialsId: 'dockerhub-pat', variable: 'PASSWORD')]) {
                    sh 'docker login -u jayakrishnanm -p $PASSWORD' 
                    sh "docker push ${dockerImageTag}"
                    
                }
            }
        }
        stage('Prepare deployment file') {
            steps{
                sh 'envsubst < myapp.yaml.template > myapp.yaml'
            }
        }
        stage('Deploy to GKE') {
            steps{
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'myapp.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
		        echo "Deployment Finished ..."
            }
        }
    }
}