pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Debug Environment') {
            steps {
                script {
                    // Print the branch name to verify it's correctly set
                    sh 'bash -c "echo Branch name is: ${env.BRANCH_NAME}"'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        // Use bash explicitly
                        sh 'bash -c "cd /var/lib/jenkins/workspace/maven-dock-jenks-pipeline/my-app && mvn clean package -P${env.BRANCH_NAME}"'
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'
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
                branch 'main'
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
