# CI/CD Demo (Jenkins + Docker)

A minimal project that serves a static HTML page from Nginx inside Docker, built and pushed to Docker Hub via Jenkins.

## Project Purpose
- Demonstrate a CI/CD flow that builds, tests, and publishes a Docker image.
- Package a single HTML page into an Nginx container.
- Deploy the container automatically from Jenkins after every GitHub push.

## Build The Docker Image Manually
```bash
docker build -t {Docker-Repo}:latest .
```

## Run The Container Manually (From Docker Hub)
```bash
docker pull {Docker-Repo}:latest
docker rm -f cicd-demo-nginx-container || true
docker run -d --name cicd-demo-nginx-container -p 8080:80 {Docker-Repo}:latest
```

Visit: `http://localhost:8080`

## Jenkins Pipeline Flow
- **Checkout**: Pulls source from GitHub.
- **Build Docker Image**: Builds and tags `midhun744/cdd` with `BUILD_NUMBER` and `latest`.
- **Test Image**: Runs a short smoke test using `curl` against the container.
- **Push Image To Docker Hub**: Logs in using the Jenkins credential ID `dockerhub-credentials` and pushes the image.
- **Stop & Remove Existing Container**: Removes any existing container on the Jenkins host.
- **Run New Container**: Pulls the latest image from Docker Hub and runs it on port 8080.

## GitHub Trigger Notes
- Configure a GitHub webhook to trigger the Jenkins job, or use the GitHub plugin trigger in the job configuration.
- The `Jenkinsfile` includes `githubPush()` which requires the Jenkins GitHub plugin.

## Requirements
- Jenkins agent with Docker installed and permission to run Docker commands.
- `curl` available on the Jenkins agent for the smoke test.
