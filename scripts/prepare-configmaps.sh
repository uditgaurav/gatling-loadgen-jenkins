#!/bin/bash
set -e

echo "[Info] Ensuring tools are available..."
apt update && apt install -y curl jq bc kubectl >/dev/null

echo "[Info]: Creating ConfigMap for simulation script..."
kubectl delete configmap gatling-simulation --namespace="$NAMESPACE" --ignore-not-found
kubectl create configmap gatling-simulation --namespace="$NAMESPACE" \
  --from-file=gatling/BasicSimulation.scala

echo "[Info]: Creating ConfigMap for execution script..."
kubectl delete configmap gatling-run-script --namespace="$NAMESPACE" --ignore-not-found
kubectl create configmap gatling-run-script --namespace="$NAMESPACE" \
  --from-file=gatling/gatling-run.sh
