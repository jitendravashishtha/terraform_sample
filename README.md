# Terraform sample
The repository contains the very simple terraform example which I am creating for my learning! Download the terraform from the following link  
https://developer.hashicorp.com/terraform/downloads  
if you are using windows just add the exe path to enviornment variable to run terraform command

## Terraform commands  
The following are the basic command to run your sample example-
* terraform version
* terraform init
* terraform validate
* terraform plan -out <plan name e.g t1.tfplan>
* terraform apply <plan name>
* terraform destroy -auto-approve

## Terraform key things to know  
* Variable  
https://developer.hashicorp.com/terraform/language/values/variables

* Provider  
https://developer.hashicorp.com/terraform/language/providers

* Data source  
https://developer.hashicorp.com/terraform/language/data-sources

* Resource   
https://developer.hashicorp.com/terraform/language/resources

* Output  
https://developer.hashicorp.com/terraform/language/values/outputs

## How to run the example
1. Update the aws_access_key and aws_secret_key in terraform.tfvars
2. Run the command in the following order 
    1.  terraform init
    2. terraform validate
    3. terraform plan -out t1.tfplan
    4. terraform apply t1.tfplan
