#!/usr/bin/env groovy

def pushVersionFile(String version, String crendentialName) {
    withCredentials([usernamePassword(credentialsId: crendentialName, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
        sh "git config --global user.email $GIT_USERNAME@github.com"
        sh "git config --global user.name $GIT_USERNAME"
        sh "git config --global user.password $GIT_PASSWORD"


        sh 'git status'
        sh 'git branch '
        sh 'git config --list'

        sh "git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/react-nodejs-example.git"
        sh 'git add .'
        sh 'git commit -m "[ci skip] Update version to $VERSION"'
        sh 'git push origin HEAD:master'
    }
}

return this