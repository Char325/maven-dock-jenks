pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    // Print the branch name to verify it's correctly set
                    echo "Branch name is: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.image('maven:3.6.3-jdk-11').inside {
                        // Use the branch name to select the Maven profile
                        if (env.BRANCH_NAME == 'main') {  
                        sh 'bash -c "mvn clean package -Pdevelopment"'
                        }
                        else{
                            echo"moving on .."
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
                    docker.image('openjdk:11-jre-slim').inside {
                        sh 'bash -c "docker build -t my-app ."'
                        sh 'bash -c "docker run --name my-app-staging -d my-app"'
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
                    docker.image('openjdk:11-jre-slim').inside('-v /var/run/docker.sock:/var/run/docker.sock'){
                        sh "docker build -t my-app:prod ."
                        sh 'bash -c "docker run --name my-app-prod -d my-app:prod"'
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
