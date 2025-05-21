FROM jenkins/inbound-agent:latest

USER root

RUN apt update && apt install -y curl jq bc && \
    KUBECTL_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/v1.30.1/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

USER jenkins
