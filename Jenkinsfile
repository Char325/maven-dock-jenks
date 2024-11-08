pipeline {
    agent any

    environment {
        ENVIRONMENT = ''
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    // Manually set the environment variable based on the branch name
                    if (env.BRANCH_NAME == 'main') {
                        env.ENVIRONMENT = 'production'
                    } else if (env.BRANCH_NAME == 'staging') {
                        env.ENVIRONMENT = 'staging'
                    } else {
                        env.ENVIRONMENT = 'development'
                    }
                    echo "Environment is: ${env.ENVIRONMENT}"
                }
            }
        }

        stage('Debug Environment') {
            steps {
                script {
                    // Print the environment to verify it's correctly set
                    echo "Debugging - Environment: ${env.ENVIRONMENT}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        // Use workspace variable
                        sh 'bash -c "echo Build - Environment: ${ENVIRONMENT}"'
                        sh 'bash -c "cd ${WORKSPACE}/my-app && mvn clean package -P${ENVIRONMENT}"'
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            when {
                environment name: 'ENVIRONMENT', value: 'staging'
            }
            steps {
                script {
                    docker.image('openjdk:11-jre-slim').inside {
                        sh 'bash -c "echo Deploy to Staging - Environment: ${ENVIRONMENT}"'
                        sh 'bash -c "cd ${WORKSPACE}/my-app && sudo docker build -t my-app ."'
                        sh 'bash -c "sudo docker run --name my-app-staging -d my-app"'
                    }
                }
            }
        }

        stage('Deploy to Production') {
            when {
                environment name: 'ENVIRONMENT', value: 'production'
            }
            steps {
                script {
                    docker.image('openjdk:11-jre-slim').inside {
                        sh 'bash -c "echo Deploy to Production - Environment: ${ENVIRONMENT}"'
                        sh 'bash -c "cd ${WORKSPACE}/my-app && sudo docker build -t my-app:prod ."'
                        sh 'bash -c "sudo docker run --name my-app-prod -d my-app:prod"'
                    }
                }
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
            cleanWs()
        }
    }
}
