#!/bin/bash
set -e

POD_NAME=$(kubectl get pods -n $NAMESPACE -l app=gatling-loadgen -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n $NAMESPACE "$POD_NAME" -- /bin/bash /tmp/gatling-run.sh
