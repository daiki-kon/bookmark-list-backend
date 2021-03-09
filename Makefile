init:
	rm -rf .terraform
	terraform init  service/

plan: 
	terraform plan service/

apply:
	terraform apply service/