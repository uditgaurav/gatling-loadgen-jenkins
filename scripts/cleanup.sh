#!/bin/bash
set -e

echo "[Info] Ensuring tools are available..."
apt update && apt install -y curl jq bc kubectl >/dev/null

kubectl delete deployment gatling-loadgen -n $NAMESPACE || true
echo "Cleanup completed."
