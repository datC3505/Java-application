pipeline {
    agent any
    environment {
        // Define environment variables
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials') // ID of your Docker Hub credentials in Jenkins
        IMAGE_TAG = "datdbq/java-sample:latest" // Replace with your Docker Hub username and image name
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/datC3505/Java-application.git'
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

        stage('SonarQube - Static Code Analysis') {
            steps {
                script {
                    // Static code analysis
                    sh 'mvn sonar:sonar -Dsonar.projectKey=java-app -Dsonar.host.url=ec2-52-66-74-201.ap-south-1.compute.amazonaws.com:9000 -Dsonar.login=squ_8820d6774a41cc76228f99677ce385f77f94ec34'
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

        stage('Scan with Trivy') {
            steps {
                script {
                    // Install Trivy
                    sh 'wget -qO- https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.tar.gz | tar xvz -C /tmp/ && mv /tmp/trivy /usr/local/bin/'

                    // Run Trivy scan
                    sh 'trivy image --exit-code 0 --no-progress ${IMAGE_TAG}'
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
 
