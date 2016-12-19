#!/bin/bash

#To install and setup Ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible -y

#To install terraform
if [ -e terraform_0.7.3_linux_amd64.zip ]; then
	echo "Terraform already exists in $PWD"
else
	echo "Downloading and setting up Terraform..."
	wget https://releases.hashicorp.com/terraform/0.8.1/terraform_0.8.1_linux_amd64.zip
	if [ -e terraform ]; then
		echo "Terraform binnary exists"
	else
		unzip terraform_0.8.1_linux_amd64.zip
	fi
fi

#To install teraform-inventory
if [ -e terraform-inventory_v0.6.1_linux_amd64.zip ]; then
	echo "Terraform Inventor already exists in $PWD"
else
	echo "Downloading and setting up Terraform Inventor..."
	wget https://github.com/adammck/terraform-inventory/releases/download/v0.6.1/terraform-inventory_v0.6.1_linux_amd64.zip
	if [ -e terraform-inventory ]; then
		echo "Terraform Inventory binnary exists"
	else
		unzip terraform-inventory_v0.6.1_linux_amd64.zip
	fi
fi

#Setting terraform binaries in env PATH
if [[ $PATH =~ .*`pwd`.* ]] ; then 
	echo "Terraform exists in the PATH"
else 
	export PATH=$PATH:`pwd`
fi

#Setup up ansbile dependencies
echo "Checking for required docker modules"
ansible-doc -l | grep -e docker_container -e docker_image -e docker_image_facts -e docker_login -e docker_service