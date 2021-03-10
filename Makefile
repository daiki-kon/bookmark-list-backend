init:
	rm -rf .terraform
	terraform init  service/

plan:
	terraform plan service/

apply:
	terraform apply -auto-approve service/

fmt:
	terraform fmt -recursive