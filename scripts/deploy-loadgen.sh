#!/bin/bash
set -e

echo "[Info] Ensuring tools are available..."
apt update && apt install -y curl jq bc kubectl >/dev/null

echo "[Info]: Deploying Gatling Pod..."
envsubst < k8s/gatling-deployment.yaml | kubectl apply -f -
