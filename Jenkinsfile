pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        sh 'mvn clean package -P${env.BRANCH_NAME}'
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
                        sh 'docker build -t my-app .'
                        sh 'docker run --name my-app-staging -d my-app'
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
