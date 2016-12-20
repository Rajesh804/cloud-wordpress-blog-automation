#!/bin/sh
##############################################################
#  Script     : cloud-automation
#  Author     : Rajesh Reddy
#  Date       : 19/12/2016
#  Last Edited: 20/12/2016, Rajesh Reddy
#  Description: "The script to AWS EC2 instances using 
#		terraform and use ansible to deploy 
#		Wordpress and MariaDB as a microservice
#		in Docker on top of Docker Compose"
##############################################################

usage() { 
echo "cloud-automation.sh -a <app name> -e <environment> -c <num_servers> -s <server_size>" 1>&2; read -p "Press any key to exit " answer; exit 1; 
}

shift $((OPTIND-1))
while getopts "a:e:c:s:" o; do
	case "$o" in
		a)
app_name=$OPTARG
;;
e)
env_name=$OPTARG
;;
c)
num_servers=$OPTARG
;;
s)
server_size=$OPTARG
;;
*)
usage
;;
esac
done

echo $app_name $env_name $num_servers $server_size
if [ -z "${app_name}" ] || [ -z "${env_name}" ]; then
	usage
fi

shift $((OPTIND-1))
read -p "AWS_ACCESS_KEY_ID: " AWS_ACCESS_KEY_ID
read -p "AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY
read -p "User name (without space): " USER_NAME
export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY 
export TF_VAR_USER_NAME=$USER_NAME
export TF_VAR_NUM_SERVERS=$num_servers
export TF_VAR_SERVER_SIZE=$server_size
export TF_VAR_ENV_NAME=$env_name
export TF_VAR_APP_NAME=$app_name
env | grep TF_VAR

export PATH=$PATH:`pwd`/terraform/bin

read -p "Press Enter to continue or Ctrl+C to cancel" confirm
cd terraform/conf.d
terraform apply .
cd ../..

KEY_PAIR=`cat terraform/conf.d/variables.tf | grep key_path -A2 | tail -1 | awk -F' = ' '{print $2}'|sed -e 's/\"//g'`
sleep 60
export TF_STATE="terraform/conf.d/terraform.tfstate"
export ANSIBLE_HOST_KEY_CHECKING=False
terraform_inventory_path=`pwd`/terraform/bin/terraform-inventory
ansible-playbook --inventory-file=$terraform_inventory_path --private-key=$KEY_PAIR ansible/deploy.yml 

GREEN=`tput setaf 2`
echo $GREEN"Deployment completed successfuly. You can access the blog by accessing the below URL:"
BLOG=`cat terraform/conf.d/terraform.tfstate | grep ebs_address -A3 | tr -d '"' | tr -d " " | tail -1 | awk -F: {'print $2'}`
echo BLOG_URL: $GREEN"http://"$BLOG
