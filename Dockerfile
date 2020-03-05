FROM golang

LABEL maintainer=paul.jones@citihub.com
ARG TERRAFORM_VERSION=0.12.20
ARG HELM_VERSION=2.13.1
ARG TERRATEST_LOG_PARSER_VERSION=0.13.13

RUN apt-get update -y \
  && apt-get install unzip -y \
  && apt-get install jq -y

RUN curl -L0 https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-$(uname -s)-$(arch) -o envsubst \
  && chmod +x envsubst \
  && mv envsubst /usr/local/bin

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/local/bin

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl; chmod +x ./kubectl; mv ./kubectl /usr/local/bin/

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz; tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz; mv linux-amd64/helm /usr/local/bin/helm;

# Install Terratest Log Parser
RUN curl --location --silent --fail --show-error -o terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v${TERRATEST_LOG_PARSER_VERSION}/terratest_log_parser_linux_amd64
RUN chmod +x terratest_log_parser
RUN mv terratest_log_parser /usr/local/bin
