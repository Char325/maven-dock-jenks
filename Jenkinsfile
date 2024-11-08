pipeline {
    agent any

    environment {
        ENVIRONMENT = ''  // Placeholder for environment variable
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    // Explicitly set the environment based on the branch
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

        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        sh 'bash -c "cd /var/lib/jenkins/workspace/maven-dock-jenks-pipeline/my-app && mvn clean package -P${env.ENVIRONMENT}"'
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
                        sh 'bash -c "cd /var/lib/jenkins/workspace/maven-dock-jenks-pipeline/my-app && sudo docker build -t my-app ."'
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
                        sh 'bash -c "cd /var/lib/jenkins/workspace/maven-dock-jenks-pipeline/my-app && sudo docker build -t my-app:prod ."'
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
