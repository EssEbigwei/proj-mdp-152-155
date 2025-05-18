pipeline {
    agent any

    environment {
        IMAGE_NAME = "appsbyess/webappcal:1.0"
        CONTAINER_NAME = "webapp-container"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: ‘project-1, url: 'https://github.com/EssEbigwei/proj-mdp-152-155.git'
            }
        }

        stage('Build WAR File') {
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
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    sh '''
                        docker rm -f $CONTAINER_NAME || true
                        docker run -d -p 9090:8080 --name $CONTAINER_NAME $IMAGE_NAME
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Please check the logs."
        }
        success {
            echo "Deployment successful! App should be running on port 9090.”
        }
    }
}
