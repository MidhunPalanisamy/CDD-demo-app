pipeline {
  agent any

  triggers {
    // Requires GitHub webhook configured for the Jenkins job
    githubPush()
  }

  environment {
    DOCKERHUB_REPO = 'midhun744/cdd'
    IMAGE_TAG = "${BUILD_NUMBER}"
    CONTAINER_NAME = 'cicd-demo-app-container'
    TEST_CONTAINER = 'cicd-demo-app-test'
  }

  stages {
    stage('Checkout') {
      steps {
        // Fetch source from the configured GitHub repository
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        // Build and tag the image for Docker Hub
        sh 'docker build -t $DOCKERHUB_REPO:$IMAGE_TAG -t $DOCKERHUB_REPO:latest .'
      }
    }

    stage('Test Image') {
      steps {
        // Smoke test: run container and verify HTTP response
        sh 'docker rm -f $TEST_CONTAINER || true'
        sh 'docker run -d --name $TEST_CONTAINER -p 18080:80 $DOCKERHUB_REPO:$IMAGE_TAG'
        sh 'sleep 2'
        sh 'curl -fsS http://localhost:18080 >/dev/null'
      }
      post {
        always {
          sh 'docker rm -f $TEST_CONTAINER || true'
        }
      }
    }

    stage('Push Image To Docker Hub') {
      steps {
        // Authenticate with Docker Hub using Jenkins credentials
        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh 'echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin'
          sh 'docker push $DOCKERHUB_REPO:$IMAGE_TAG'
          sh 'docker push $DOCKERHUB_REPO:latest'
          sh 'docker logout'
        }
      }
    }

    stage('Stop & Remove Existing Container') {
      steps {
        // Stop and remove any existing container to avoid port conflicts
        sh 'docker rm -f $CONTAINER_NAME || true'
      }
    }

    stage('Run New Container') {
      steps {
        // Pull the latest image from Docker Hub and run it
        sh 'docker pull $DOCKERHUB_REPO:latest'
        sh 'docker run -d --name $CONTAINER_NAME -p 8080:80 $DOCKERHUB_REPO:latest'
      }
    }
  }
}
