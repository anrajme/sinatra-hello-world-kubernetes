pipeline {
  agent any
  stages {
    stage('Docker Build') {
      steps {
        sh "docker build -t anraj/hello-sinatra:${env.BUILD_NUMBER} ."
      }
    }
    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push anraj/hello-sinatra:${env.BUILD_NUMBER}"
        }
      }
    }
  }
  agent { docker { image 'ruby:2.6.1' } }
  stages {
    stage('Unit test') {
      steps {
        
          sh "gem install bundler -v 2.0.1"
          sh "bundle install"
          sh 'rake ci:all'
        
      }
      post {
        always {
          junit 'test/reports/TEST-AppTest.xml'
        }
    }
  agent any
  stages {

    stage('Remove Image locally') {
      steps {
        sh "docker rmi anraj/hello-sinatra:${env.BUILD_NUMBER}"
      }
    }
    stage('Deploy app in Kubernetes') {
      steps {
          withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'cat deployment.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" | kubectl apply -f -'
          sh 'kubectl apply -f service.yaml'
        }
      }
  }
}
post {
    success {
      slackSend(message: "Pipeline is successfully completed.")
    }
    failure {
      slackSend(message: "Pipeline failed. Please check the logs.")
    }
}
}