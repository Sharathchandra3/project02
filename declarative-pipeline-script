pipeline {
    agent any

    environment {
        APP_REPO = 'https://github.com/Sharathchandra3/car-booking.git'
        DOCKERFILE_REPO = 'https://github.com/Sharathchandra3/project02.git'
        SONARQUBE_SERVER = 'sonarqube'
        ARTIFACTORY_URL = 'http://13.203.76.72:8082/artifactory'
        ARTIFACTORY_REPO = 'project02'
        IMAGE_NAME = '1sharathchandra/project02'
        APP_VERSION = '1.0.0'
    }

    stages {
        stage('Clone Repos') {
            steps {
                dir('app') {
                    git url: "${APP_REPO}", branch: 'dev'
                }
                dir('docker') {
                    git url: "${DOCKERFILE_REPO}", branch: 'main'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('app') {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        sh 'mvn clean verify sonar:sonar'
                    }
                }
            }
        }

        stage('Build WAR with Maven') {
            steps {
                dir('app') {
                    sh 'mvn package -DskipTests'
                }
            }
        }

        stage('Upload WAR to JFrog') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'jfrog-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                    curl -u $USERNAME:$PASSWORD -T app/taxi-booking/target/cabbooking.war \
                    "${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/cabbooking/${APP_VERSION}/cabbooking-${APP_VERSION}.war"
                    '''
                }
            }
        }

        stage('Prepare and Build Docker Image') {
            steps {
                sh '''
                docker image prune -f
                docker rmi $(docker images -f "reference=${IMAGE_NAME}" -q) || true
                '''
                withCredentials([usernamePassword(credentialsId: 'jfrog-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                    curl -u $USERNAME:$PASSWORD \
                    -o cabbooking-${APP_VERSION}.war \
                    "${ARTIFACTORY_URL}/${ARTIFACTORY_REPO}/cabbooking/${APP_VERSION}/cabbooking-${APP_VERSION}.war"
                    '''
                }
                sh '''
                cp cabbooking-${APP_VERSION}.war docker/app.war
                docker build -t ${IMAGE_NAME}:${APP_VERSION} -t ${IMAGE_NAME}:latest docker
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                    echo $DOCKER_TOKEN | docker login -u 1sharathchandra --password-stdin
                    docker push ${IMAGE_NAME}:${APP_VERSION}
                    docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }
    }
}
