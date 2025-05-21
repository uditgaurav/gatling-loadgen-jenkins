#!/bin/bash
set -e
kubectl delete deployment gatling-loadgen -n $NAMESPACE || true
echo "Cleanup completed."
