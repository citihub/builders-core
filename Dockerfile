FROM golang

LABEL maintainer=paul.jones@citihub.com

ARG TERRAFORM_VERSION=0.14.4
ARG HELM_VERSION=3.3.4
ARG TERRATEST_LOG_PARSER_VERSION=0.13.13
ARG ISTIO_VERSION=1.7.4
ARG ISTIO_FLAVOUR="x86_64"
ARG CONFTEST_VERSION=0.21.0

# Install jq
RUN apt-get update -y \
  && apt-get install unzip -y \
  && apt-get install jq -y

# Install envsubst
RUN curl -L0 https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-$(uname -s)-$(arch) -o envsubst \
  && chmod +x envsubst \
  && mv envsubst /usr/local/bin

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/local/bin

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/

# Install Helm
RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin/helm

# Install Istioctl
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=${ISTIO_FLAVOUR} sh - \
  && mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl

# Install Terratest Log Parser
RUN curl --location --silent --fail --show-error -o terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v${TERRATEST_LOG_PARSER_VERSION}/terratest_log_parser_linux_amd64 \
  && chmod +x terratest_log_parser \
  && mv terratest_log_parser /usr/local/bin

# Install conftest
RUN wget https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
  && tar xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
  && mv conftest /usr/local/bin

# Install gcloud sdk
RUN curl -sSL https://sdk.cloud.google.com > /tmp/gc \
  && bash /tmp/gc --disable-prompts \
  && /root/google-cloud-sdk/bin/gcloud components install beta --quiet

ENV PATH=$PATH:/root/google-cloud-sdk/bin
