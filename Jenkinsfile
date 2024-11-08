pipeline {
    agent {
        docker {
            image 'docker:20.10.7' // Use a Docker image with Docker pre-installed
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    echo "Branch name is: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        if (env.BRANCH_NAME == 'main') {  
                            sh 'bash -c "mvn clean package -Pdevelopment"'
                        } else {
                            echo "moving on .."
                        }
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
                    sh 'bash -c "docker build -t my-app ."'
                    sh 'bash -c "docker run --name my-app-staging -d my-app"'
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
            junit '**/target/surefire-reports/*.xml'
            cleanWs()
        }
    }
}
