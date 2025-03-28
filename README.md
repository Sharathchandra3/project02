Cloud Automation Project
This project automates EC2 instance management, Jenkins CI/CD pipeline, SonarQube code validation, Maven WAR build, Docker image creation, and deployment to AWS EKS.

Components:
EC2 Management: create-delete.py lists and terminates EC2 instances.

Jenkins Setup: install-jenkins.sh installs and configures Jenkins on EC2.

SonarQube: Validates code quality and security.

Maven: Builds the application into a WAR file.

JFrog: WAR file is pushed to JFrog Artifactory.

Docker: Builds and pushes a Docker image.

Kubernetes: Deploys to AWS EKS using deployment.yaml and service.yaml.

Workflow:
Code is pulled from GitHub.

SonarQube validates the code.

Maven builds the WAR file.

WAR is pushed to JFrog.

Docker image is created and deployed to EKS.

Automates CI/CD using AWS, Jenkins, SonarQube, Docker, JFrog, and Kubernetes.