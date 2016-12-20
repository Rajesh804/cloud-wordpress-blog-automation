#!/bin/bash
##############################################################
#  Script     : setup_prerequisites
#  Author     : Rajesh Reddy
#  Date       : 19/12/2016
#  Last Edited: 20/12/2016, Rajesh Reddy
#  Description: The script to setup ansible and terraform
##############################################################

GREEN=`tput setaf 2`
RED=`tput setaf 1`

#To install and setup Ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible -y

if [ -d "terraform/bin" ] ; then 
	echo "bin dir already exists"
else 
	mkdir terraform/bin
fi

#To install terraform
echo "*********Setting up terraform*********"
if [ -e terraform_0.8.1_linux_amd64.zip ]; then
	echo "Terraform ZIP already exists in $PWD. Checking for binnary"
	if [ -e "terraform/bin/terraform" ]; then
		echo "Terraform binnary exists in $PWD/terraform/bin"
	else
		unzip terraform_0.8.1_linux_amd64.zip -d terraform/bin
	fi
else
	echo "Downloading and setting up Terraform..."
	wget https://releases.hashicorp.com/terraform/0.8.1/terraform_0.8.1_linux_amd64.zip
	unzip terraform_0.8.1_linux_amd64.zip -d terraform/bin
fi

#To install teraform-inventory
echo "*********Setting up terraform-inventory*********"

if [ -e terraform-inventory_v0.6.1_linux_amd64.zip ]; then
	echo "Terraform Inventor ZIP already exists in $PWD. Checking for binnary"
	if [ -e "terraform/bin/terraform-inventory" ]; then
		echo "Terraform Inventory binnary exists in $PWD/terraform/bin"
	else
		unzip terraform-inventory_v0.6.1_linux_amd64.zip -d terraform/bin
	fi
else
	echo "Downloading and setting up Terraform Inventor..."
	wget https://github.com/adammck/terraform-inventory/releases/download/v0.6.1/terraform-inventory_v0.6.1_linux_amd64.zip
	unzip terraform-inventory_v0.6.1_linux_amd64.zip -d terraform/bin
fi

if [ $? == 0 ];then
	echo $GREEN"Prerequisties setup completed successfully"
else
	echo $RED"Prerequisties setup failed"
fi
