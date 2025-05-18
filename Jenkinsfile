pipeline {
    agent any

    environment {
        IMAGE_NAME = "appsbyess/webappcal:latest"
        CONTAINER_NAME = "webapp-container"
        PORT = "9090"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: ‘project-1', url: 'https://github.com/EssEbigwei/proj-mdp-152-155.git'
            }
        }

        stage('Build WAR') {
            steps {
                script {
                    docker.image('maven:3.8.1-openjdk-8').inside {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true
                    docker run -d --name $CONTAINER_NAME -p 9090:8080 $IMAGE_NAME
                '''
            }
        }
    }
}
