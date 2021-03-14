init:
	rm -rf .terraform
	terraform init  service/

plan:
	terraform plan service/

apply:
	terraform apply -auto-approve service/

fmt:
	terraform fmt -recursive

pip:
	pip3 install -t ./modules/lambda/lib/requests/python/ requests
	pip3 install -t ./modules/lambda/lib/beautifulsoup4/python/ beautifulsoup4