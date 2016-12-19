### cloud-wordpress-blog-automation
To build a Wordpress blog with ansible, terraform, docker and shell scripts in an automated way...

## Getting Started
The instructions below would get you the Wordpress Blog project up and running on your AWS Cloud.

### Prerequisites
1. Ansible
2. Terraform
3. Terraform Inventory
4. Ansible Docker/Docker-Compose modules check

### Requirements
1. A Linux workstation
2. An AWS account with vpc and subnets
3. Currently the scripts and playbooks have been tested only for ubuntu 14 trusty.
4. Kindly follow each and every step to achieve a successful working wordpress blog.

### Setup Instructions:

First clone the repo to your Linux Workstation

```
cd ~/
git clone https://github.com/Rajesh804/cloud-wordpress-blog-automation.git
cd cloud-wordpress-blog-automation
```

###There are two shell scripts for use.
1. setup_prerequisites.sh
2. cloud-automation.sh

##setup_prerequisites.sh: 
This script could be used for setting up all the Prerequisites that are required. It could be used by any one who wants to have the ansible and terraform scripts to be working. To execute the script, use the below command:

```
./setup_prerequisites.sh
```

##cloud-automation.sh:
This script is the main script which is responsible for setting up the required running environment. Before running the script, please make sure you have all the correct variables inside terraform/conf.d/variables.tf files for below:

          aws_region = "<AWS Region>"
          key_path = "<AWS PEM key path>" 
          key_name = "<Name of the key pair>"
          subnet_id = "<subnet id that you want to use>"
          vpc_id = "<vpc id that you want to use>"

After that, please execute the below command to start the provisioning of the respective environment

```
./cloud-automation.sh -a wp-blog -e dev -c 1 -s "t2.micro"
```
-a represents the name of the application for identification
-e represents the name of the environment
-c represents the number of instance 
-a represents the type of the ec2 instance

After this, you should be having a working environment of your wordpress blog.

## Continuous Integration & Delivery
This is the process where we can automate the building of our own docker containers using *Jenkins* using "Dockerfile" and push them to our private *Docker Registry*. And then we can set the required versions of containers in the ansible playbook and that will eventually deploy the required version of the code. 
