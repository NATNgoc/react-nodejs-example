pipeline {

    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building the react app...'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing the react app...'
            }
        }

        stage('Deploy') {
            stages {
                stage('Build Docker Artifact') {
                    steps {
                        sh 'docker build -t natn2003/test-auto:v1.0.0-SNAPSHOT .'
                        sh 'docker images'
                    }
                }
                stage('Deploy to Docker Hub') {
                    steps {
                        sh 'docker push natn2003/test-auto:v1.0.0-SNAPSHOT'
                    }
                }
                stage('Deploy to staging') {
                    steps {
                        sshagent(['jenkins-sever-ssh-key']) {
                            sh 'ssh jenkins@13.211.158.61'
                            sh 'docker run -d -p 8080:3080 natn2003/test-auto:v1.0.0-SNAPSHOT'
                        }
                    }
                }
                
                
            }
        }
    }
}