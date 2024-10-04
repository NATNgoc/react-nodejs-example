pipeline {
    agent any
    
    tools {
        nodejs 'node-10'
    }
 
    
    stages {
        stage('Check if a commit by cicd pipeline') {
                steps {
                    scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                }
        }
        stage("Increase version") {
            steps {
                sh 'npm --prefix ./api version patch'
                script {
                    sh 'pwd'
                    sh 'ls -la'
                    def scriptGetVersion = sh(script: 'bash getVersionPatch.sh api/package.json', returnStdout: true).trim()
                    env.VERSION = scriptGetVersion
                    echo "Increased Version: $VERSION"
                }
            }
        }
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
                        sh "docker build -t natn2003/test-auto:${VERSION}-SNAPSHOT ."
                        sh 'docker images'
                    }
                }
                stage('Deploy to Docker Hub') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-crendential',
                     usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                           sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                           sh "docker push natn2003/test-auto:${VERSION}-SNAPSHOT"
                        }
                    }
                }
                stage('Deploy to staging') {
                    steps {
                        sshagent(['aws-auto-deploy']) {
                            sh '''
                                ssh -o StrictHostKeyChecking=no ec2-user@13.211.158.61 "
                                docker ps --format '{{.Ports}}\t{{.ID}}' | grep ':8081->' | cut -f2 | xargs -r docker stop
                                docker pull natn2003/test-auto:${VERSION}-SNAPSHOT &&
                                docker run -d -p 8081:3080 natn2003/test-auto:${VERSION}-SNAPSHOT
                                "
                            '''
                        }
                    }
                }
            }
        }
        stage('Push version file to github') {
            steps {
                script {
                    def crendentialName = 'github-crendential'
                def scriptPushVersionFile = load 'pushVersionFile.groovy'
                    scriptPushVersionFile(env.VERSION, crendentialName)
                }
            }
        }
    }
}