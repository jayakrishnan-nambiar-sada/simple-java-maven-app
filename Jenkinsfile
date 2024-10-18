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
        PROJECT_ID = 'sadaindia-poc-infra-1700'
        CLUSTER_NAME = 'sada-tu-poc-gke-1'
        LOCATION = 'us-central1-c'
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
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/tag/${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', verifyDeployments: true])
		        echo "Deployment Finished ..."
            }
        }
    }
}