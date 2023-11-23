pipeline {
    agent any
parameters {
  choice choices: ['Dev', 'Test', 'UAT', 'Prod'], description: 'Choose the stage to deploy', name: 'stage'
  string description: 'Enter your Name ', name: 'triggred_by'
}

    environment {
        // Define environment variables
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials') // ID of your Docker Hub credentials in Jenkins
        IMAGE_TAG = "mahesh430/java-sample:latest" // Replace with your Docker Hub username and image name
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/mahesh430/sample-java-application.git'
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    // Run Maven build and test
                    sh 'mvn clean package'
                }
            }
        }
        
  stage('SoarQube - Static Code Analysis') {
            steps {
                script {
                    // Static code analysis
                    sh 'mvn sonar:sonar -Dsonar.projectKey=java-app -Dsonar.host.url=http://18.222.25.49:9000 -Dsonar.login=7168448a52cb42b70f6b7b46d8419032bce0f406'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Building Docker Image
                    sh "docker build -t ${IMAGE_TAG} ."
                }
            }
        }
   stage('Docker image scan') {
            steps {
                script {
                    // Scan  Docker Image
                   sh "trivy image --exit-code 0 --no-progress ${IMAGE_TAG}"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    // Pushing Image to Docker Hub
                    sh "docker push ${IMAGE_TAG}"
                }
            }
        }

    }

    post {
        always {
            // Clean up Docker images
            sh "docker rmi ${IMAGE_TAG}"
        }
    }
}

