pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside('-v /var/run/docker.sock:/var/run/docker.sock') {
                        if (env.BRANCH_NAME == 'main') {
                            sh 'mvn clean package -Pdevelopment'
                        } else {
                            echo "moving on .."
                        }
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    // Stop and remove existing container if it exists
                    sh 'if [ "$(docker ps -a -q -f name=my-app-staging)" ]; then docker stop my-app-staging; docker rm my-app-staging; fi'
                    sh 'docker build -t my-app .'
                    sh 'docker run --name my-app-staging -d my-app'
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Stop and remove existing container if it exists
                    sh 'if [ "$(docker ps -a -q -f name=my-app-prod)" ]; then docker stop my-app-prod; docker rm my-app-prod; fi'
                    sh 'docker build -t my-app:prod .'
                    sh 'docker run --name my-app-prod -d my-app:prod'
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Check for existing containers and destroy them
                    sh 'if [ "$(docker ps -a -q)" ]; then docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); fi'
                }
            }
        }
    }

    
}
