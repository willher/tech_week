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

## README.md

As John said:

> Read the documentation and practice doing stuff in markdown language!

First Header | Second Header
------------ | -------------
This is the content I want under header One | This is content I want under header Two
This is me making a second row | Hello from the second row, second column

Yo, @johhess40 I'm trying to use mentions here

~~This was an error I needed to cross out~~

Oh and yes, markdown supports emojis :grinning: :smile: :hole: