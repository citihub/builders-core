FROM golang:1.13
LABEL description="Published as citihub/go-jq:latest on Docker Hub"
RUN apt-get -y update && apt-get -y install jq