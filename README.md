# Jenking_CICD_Pipeline
## Prequisite:
- Installed virtual machine 'UBUNTU-22.04' on my machine.
- Installed Jenkins by following below steps on virtual machine.

## Created EC2 instance as a staging environment with all dependencies.
![alt text](Readme_File_Images/image-32.png)
![alt text](Readme_File_Images/image-33.png)

## Installed Jenkins on source machine:
```
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-11-jdk -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
- Get Jenkins Running Port Number
```bash
sudo netstat -tuln | grep 8080
```
- Get Jenkins Running Server Ip
```
ip addr show eth0 -> 172.29.183.172
```
- Accessed Jenkin via port 8080
```
172.29.183.172:8080
```
- Get Jenkins first time passowrd for jenkins & user setup
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
## Configured Jenkins with Python with below necessary libraries
```
sudo apt update
sudo apt install python3 python3-pip -y
python3 --version
pip3 --version
pip3 install flask
pip install pytest
apt install python3.10-venv
```
## Installed below Jenkins Plugins for Python from Jenkin dashboard
- ShiningPanda
- Pipeline Plugin
- 
## Forked the simple Python flask web application repository on GitHub.
![alt text](Readme_File_Images/image-24.png)

## Cloned the forked repository into Jenkins server.
```
git clone https://github.com/PankajGacche/Jenking_CICD_Pipeline.git
```
## Created a Jenkinsfile in the root of your Python application repository.
![alt text](Readme_File_Images/image-13.png)
![alt text](Readme_File_Images/image-14.png)
![alt text](Readme_File_Images/image-15.png)
![alt text](Readme_File_Images/image-16.png)
![alt text](Readme_File_Images/image-17.png)

## Created deploy-to-staging.sh file for code deployment in staging enviornment.
![alt text](Readme_File_Images/image-18.png)
![alt text](Readme_File_Images/image-19.png)
![alt text](Readme_File_Images/image-20.png)
![alt text](Readme_File_Images/image-21.png)

## Created test case to run unit tests using a testing framework like pytest.
![alt text](Readme_File_Images/image-22.png) 

## Created requirements.txt file for listing out all package dependencies.
![alt text](Readme_File_Images/image-23.png)

## Logged in with Jenkins user and created ne pipeline with below stages:
- Build
- Test
- Set Permissions
- Deploy to EC2
  
## Configure the pipeline to trigger a new build whenever changes are pushed to the main branch of the repository.
## Set up a notification system to alert via email when the build process fails or succeeds.

## Pipeline Flow Screenshots:
![alt text](Readme_File_Images/image-1.png)
![alt text](Readme_File_Images/image-2.png)
![alt text](Readme_File_Images/image-3.png)
![alt text](Readme_File_Images/image-4.png)
![alt text](Readme_File_Images/image-5.png)
![alt text](Readme_File_Images/image-6.png)
![alt text](Readme_File_Images/image-7.png)
![alt text](Readme_File_Images/image-8.png)
![alt text](Readme_File_Images/image-9.png)
![alt text](Readme_File_Images/image-10.png)

## Source code Jenking workspace:
![alt text](Readme_File_Images/image-11.png)

## Staging enviornment where code deployed successfully:
![alt text](Readme_File_Images/image-12.png)

## Recieved email notification on successfull build trigger
![alt text](Readme_File_Images/image-25.png)

## Recieved email notification on failed build trigger
![alt text](Readme_File_Images/image-26.png)
![alt text](Readme_File_Images/image-27.png)
![alt text](Readme_File_Images/image-28.png)
![alt text](Readme_File_Images/image-29.png)

## Fixed the issue and pushed changes auto trigger build and successfull.
![alt text](Readme_File_Images/image-30.png)
![alt text](Readme_File_Images/image-31.png)












