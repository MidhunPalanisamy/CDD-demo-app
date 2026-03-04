pipeline {
  agent any

  triggers {
    githubPush()
  }

  environment {
    DOCKER = "/usr/local/bin/docker"
    DOCKERHUB_REPO = "midhun744/cdd"
    IMAGE_TAG = "${BUILD_NUMBER}"
    CONTAINER_NAME = "cicd-demo-app-container"
    TEST_CONTAINER = "cicd-demo-app-test"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '$DOCKER build -t $DOCKERHUB_REPO:$IMAGE_TAG -t $DOCKERHUB_REPO:latest .'
      }
    }

    stage('Test Image') {
      steps {
        sh '$DOCKER rm -f $TEST_CONTAINER || true'
        sh '$DOCKER run -d --name $TEST_CONTAINER -p 18080:80 $DOCKERHUB_REPO:$IMAGE_TAG'
        sh 'sleep 3'
        sh 'curl -fsS http://localhost:18080 >/dev/null'
      }
      post {
        always {
          sh '$DOCKER rm -f $TEST_CONTAINER || true'
        }
      }
    }

    stage('Push Image To Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo $DOCKERHUB_PASS | $DOCKER login -u $DOCKERHUB_USER --password-stdin'
          sh '$DOCKER push $DOCKERHUB_REPO:$IMAGE_TAG'
          sh '$DOCKER push $DOCKERHUB_REPO:latest'
          sh '$DOCKER logout'
        }
      }
    }

    stage('Deploy Container') {
      steps {
        sh '$DOCKER rm -f $CONTAINER_NAME || true'
        sh '$DOCKER pull $DOCKERHUB_REPO:latest'
        sh '$DOCKER run -d --name $CONTAINER_NAME -p 8080:80 $DOCKERHUB_REPO:latest'
      }
    }
  }
}