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

```
stage('Checkout') {
  steps {
    checkout scm
  }
}

stage('Docker Login') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
      sh 'echo $DOCKER_PASS | $DOCKER login -u $DOCKER_USER --password-stdin'
    }
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
    sh '$DOCKER push $DOCKERHUB_REPO:$IMAGE_TAG'
    sh '$DOCKER push $DOCKERHUB_REPO:latest'
  }
}

stage('Deploy Container') {
  steps {
    sh '$DOCKER rm -f $CONTAINER_NAME || true'
    sh '$DOCKER pull $DOCKERHUB_REPO:latest'
    sh '$DOCKER run -d --name $CONTAINER_NAME -p 8080:80 $DOCKERHUB_REPO:latest'
  }
}
```

}

post {
always {
sh '$DOCKER logout || true'
}
}
}
