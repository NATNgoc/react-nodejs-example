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
                //Test Auto github
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
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-crendential',
                     usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                           sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                           sh 'docker push natn2003/test-auto:v1.0.0-SNAPSHOT'
                        }
                    }
                }
                stage('Deploy to staging') {
                    steps {
                        sshagent(['aws-auto-deploy']) {
                            sh '''
                                ssh -o StrictHostKeyChecking=no ec2-user@13.211.158.61 "
                                docker ps --format '{{.Ports}}\t{{.ID}}' | grep ':8081->' | cut -f2 | xargs -r docker stop
                                docker pull natn2003/test-auto:v1.0.0-SNAPSHOT &&
                                docker run -d -p 8081:3080 natn2003/test-auto:v1.0.0-SNAPSHOT
                                "
                            '''
                        }
                    }
                }
            }
        }
    }
}