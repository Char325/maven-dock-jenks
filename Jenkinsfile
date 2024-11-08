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
                    docker.image('maven:3.6.3-jdk-11').inside {
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
                    sh 'docker build -t my-app:prod .'
                    sh 'docker run --name my-app-prod -d my-app:prod'
                }
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml' // Specify the directory and file pattern for test reports
            cleanWs()
        }
    }
}
