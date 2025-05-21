#!/bin/bash
set -e

echo "[Info]: Deploying Gatling Pod..."
envsubst < k8s/gatling-deployment.yaml | kubectl apply -f -
