# Verify project dependencies are installed
$(if $(shell command -v brew 2> /dev/null),$(info),$(error Please install Homebrew https://brew.sh))

project_name = "gcpizza"
email = "james.olds@adhocteam.us"
project_id = ${project_name}
subdomain = ${project_name}

gcloud_path := $(shell brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
gcloud := ${gcloud_path}/bin/gcloud

help: Makefile
	@sed -n 's/^##//p' $<
.PHONY: help

##
##Misc Targets
##install-tools:		Install project dependencies on the local host
install-tools:
	-brew install --cask google-cloud-sdk
.PHONY: install-tools

##
##gcloud Targets
##gcloud-path:		Configure your shell's PATH with google-cloud-sdk tools
gcloud-path:
	bash ${gcloud_path}/install.sh
.PHONY: gcloud-path

##gcloud-init:		Initialize gcloud SDK and configure project
gcloud-init:
	${gcloud} init
.PHONY: gcloud-init

##gcloud-auth:		Authorize gcloud SDK
gcloud-auth:
	${gcloud} auth login --no-launch-browser
.PHONY: gcloud-auth

##gcloud-billing:		Enable gcloud billing
account_id = $(shell ${gcloud} alpha billing accounts list --format="value(ACCOUNT_ID)")
gcloud-billing:
	${gcloud} alpha billing projects link ${project_name} --billing-account ${account_id}
.PHONY: gcloud-billing

##gcloud-services:		Enable gcloud services
gcloud-services:
	${gcloud} services enable cloudbuild.googleapis.com
.PHONY: gcloud-services

##gcloud-deploy:		Deploy to App Engine and configure IAP
gcloud-deploy: gcloud-billing gcloud-services
	${gcloud} app deploy
.PHONY: gcloud-deploy

##
##Application Targets
##app-image:		Builds the application's container image
app-image:
	@echo "Building application Docker image"
	@docker build --quiet -t ${project_name} .
.PHONY: app-image

##app-server:		Start the server in the container environment,
##			accessible on the host at http://0.0.0.0:8000
app-server: app-image
	@docker run -it -p 8000:8000 ${project_name}
.PHONY: app-server
