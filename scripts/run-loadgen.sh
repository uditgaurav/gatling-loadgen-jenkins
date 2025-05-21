#!/bin/bash
set -e

echo "[Info] Ensuring tools are available..."
apt update && apt install -y curl jq bc kubectl >/dev/null


POD_NAME=$(kubectl get pods -n $NAMESPACE -l app=gatling-loadgen -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n $NAMESPACE "$POD_NAME" -- /bin/bash /tmp/gatling-run.sh
