# whertwec

You can contact me with any questions via Microsoft teams or email: willis.hertweck@cdw.com

## terraform

Use the main.tf file to generate Azure resource group and the other items outlines by Tech Week Labs.  
**Pay speacial attention to how I implimented map(obj) in "subnets"**
**Also note how I used locals in azurerm_network_interface**

Use the variables.tf file to assign variables to objects
Use the terraform.tfvars to set deployment specific values to the variables in the variables.tf file

## Packer

Takes inputs variables from Azure portal and attempts to build a vm running the specified version of Redhat.
Currently failing due to restrictions on my portal.azure.com Resource group.  Need to add tags similar to those seen in terraform to address this.

## Ansible

playbook.yaml updates VM, downloads NGINX, runs a yum install of the image, creates a index page, and starts nginx
nginx.conf contains the configuration information for nginx including having port 80 open. 
index.html serves up a basic 'Hello World' html file