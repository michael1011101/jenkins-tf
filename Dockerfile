# Starting from a base Alpine image
FROM alpine:latest

# Update and install necessary software
RUN apk update && apk add git wget unzip curl

# Set version of Terraform
ARG TERRAFORM_VERSION=1.8.5

# Download Terraform binaries
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Unzip and install Terraform
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/
RUN rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip


# Copy a local directory into the Docker container
RUN mkdir -p /workspace
COPY *.tf /workspace

WORKDIR /workspace

# Check that installations were successful and output versions
RUN git --version && terraform -version
