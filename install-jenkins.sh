#!/bin/bash

# This script will install Jenkins and its dependencies on Amazon Linux 2

# Step 1: Update the System
echo "Updating the system..."
sudo yum update -y

# Step 2: Install Java (Required for Jenkins)
echo "Installing Java 17 (Amazon Corretto)..."
sudo yum install java-17-amazon-corretto -y

# Step 3: Verify Java Installation
echo "Verifying Java Installation..."
java -version

# Step 4: Download Jenkins GPG Key and Add Jenkins Repository
echo "Downloading Jenkins GPG key and adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Step 5: Install Git and Maven
echo "Installing Git and Maven..."
sudo yum install -y git maven 

# Step 6: Install Docker
echo "Installing Docker..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# Step 7: Install Jenkins
echo "Installing Jenkins..."
sudo yum install -y jenkins

# Step 8: Start Jenkins and Enable Jenkins to Start on Boot
echo "Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Step 9: Access Jenkins
echo "Jenkins installation completed. You can access Jenkins at http://<host-ip>:8080"

# Step 10: Display the Initial Admin Password
echo "Displaying Jenkins Initial Admin Password..."
cat /var/lib/jenkins/secrets/initialAdminPassword

# Step 11: Add Jenkins user to Docker group (so Jenkins can interact with Docker)
echo "Adding Jenkins user to Docker group..."
sudo usermod -aG docker jenkins

# Step 12: Restart Jenkins
echo "Restarting Jenkins..."
sudo systemctl restart jenkins
