#!/usr/bin/env bash

# file name..: build.sh
# author.....: Vinicius Figueiredo <vinicius.figueiredo@zoop.co>
# description: Automates Terraform to build AWS infrastructure.

LOG_FILE="build.log"
COMMIT_HASH=$(git log --pretty=format:%h -n 1)
REPO_NAME="devops/hello-api"


f_log() {
  echo "$(date -Iseconds) - $@" | tee -a ${LOG_FILE}
}

f_clean() {
	f_log "Cleaning temporary files and directories..."
        find . -name "*.log" -exec rm {} \;
	rm -rf terraform/tfplan* .terraform/ .terraform_init.lock
}

f_build_testplan() {
	f_terraform_init

	terraform plan \
		-no-color \
		-var-file=environments/${ENV}.tfvars \
		-input=false
}

f_build_plan() {
	f_terraform_init

	export TFPLAN="tfplan-${ENV}-${COMMIT_HASH}"

	f_log "Calling Terraform plan, configured variables:"
	f_log "  var-file=environments/${ENV}.tfvars"
	f_log "  out=tfplan-${ENV}-${COMMIT_HASH}"

	terraform plan \
		-no-color \
		-var-file=environments/${ENV}.tfvars \
		-out=${TFPLAN} \
		-input=false >> ${TFPLAN}.out

	if [ $? -eq 1 ]; then
		f_log "ERROR, Terraform failed, aborting..."
		exit 1
	fi

	f_log "Terraform plan created at terraform/${TFPLAN}."
}


f_build_apply() {
	f_terraform_init

	export TFPLAN="tfplan-${ENV}-${COMMIT_HASH}"

	f_log "Calling Terraform apply on terraform/${TFPLAN}"
	terraform apply "${TFPLAN}" -no-color

	if [ $? -eq 0 ]; then
		f_log "Terraform successfully applied changes, ${TFPLAN} deployed."
        else
		f_log "ERROR, Terraform failed, aborting..."
		exit 1
	fi
}

f_terraform_init() {
	if [ -z ${ENV} ]; then
		f_log "ERROR, environment variable ENV not set."
		exit 1
	fi

	WS=${ENV}

	if [ -f .terraform_init.lock ]; then
		if [[ $(cat .terraform_init.lock) == ${WS} ]]; then
			f_log "Terraform already initialized!"
		else
			f_log "ERROR, Terraform already initialized for another workspace."
			f_log "Run 'build.sh clean"
			exit 1
		fi
	else
		export TF_LOG_PATH=terraform.log

                cd terraform

		f_log "Trying to initialize Terraform..."
		terraform init -no-color
			if [ -z "`terraform workspace list | grep ${WS}`" ] ; then
				terraform get -no-color && \
				terraform workspace new ${WS}
				f_log "Created and switched to workspace ${WS}!"
			else
				terraform get -no-color && \
				terraform workspace select ${WS} -no-color
				f_log "Workspace ${WS} selected!"
			fi

		if [ $? -eq 0 ]; then
			f_log "Terraform successfully initialized!"
			echo ${WS} > .terraform_init.lock
		else
			f_log "ERROR, Terraform failed, aborting..."
			exit 1
		fi
	fi
}

f_terraform_refresh() {
        f_terraform_init

        terraform refresh -var-file=environments/${ENV}.tfvars
}

f_docker_build_image() {
        docker build -t ${REPO_NAME} .
}

case "$1" in
        clean)
                f_clean
        ;;

	plan)
		f_build_plan
	;;

	apply)
		f_build_apply
	;;

	testplan)
		f_build_testplan
	;;

	init)
		f_terraform_init
	;;

	refresh)
		f_terraform_refresh
	;;

        build-image)
                f_docker_build_image
        ;;

	*)
		echo "usage: build.sh testplan|plan|apply|clean|refresh"
		exit 0
	;;
esac
