#!/bin/bash

set -e

: "${ACCOUNT_ID:?ACCOUNT_ID is required}"
: "${ORG_ID:?ORG_ID is required}"
: "${PROJECT_ID:?PROJECT_ID is required}"
: "${WORKFLOW_ID:?WORKFLOW_ID is required}"
: "${API_KEY:?API_KEY is required}"
: "${EXPECTED_RESILIENCE_SCORE:?EXPECTED_RESILIENCE_SCORE is required}"

DELAY="${DELAY:-2}"
TIMEOUT="${TIMEOUT:-500}"

echo "[Info] Ensuring tools are available..."
apt update && apt install -y curl jq bc kubectl >/dev/null


echo "Downloading HCE CLI..."
curl -sL https://storage.googleapis.com/hce-api/hce-api-linux-amd64 -o hce-cli
chmod +x hce-cli

echo "Launching Chaos Experiment..."
NOTIFY_ID=$(./hce-cli generate --api launch-experiment \
  --account-id="${ACCOUNT_ID}" \
  --project-id="${PROJECT_ID}" \
  --workflow-id="${WORKFLOW_ID}" \
  --api-key="${API_KEY}" \
  --file-name hce-api.sh | jq -r '.data.runChaosExperiment.notifyID')

if [[ -z "$NOTIFY_ID" || "$NOTIFY_ID" == "null" ]]; then
  echo "[Error]: Failed to retrieve notify ID for the experiment."
  exit 1
fi

echo "[Info]: Experiment launched successfully with notify ID: $NOTIFY_ID"

echo "Monitoring Chaos Experiment..."
./hce-cli generate --api monitor-experiment \
  --account-id="${ACCOUNT_ID}" \
  --org-id="${ORG_ID}" \
  --project-id="${PROJECT_ID}" \
  --api-key="${API_KEY}" \
  --delay="${DELAY}" \
  --timeout="${TIMEOUT}" \
  --notify-id="${NOTIFY_ID}"

echo "Validating Resilience Score..."
RESILIENCY_SCORE=$(./hce-cli generate --api validate-resilience-score \
  --account-id="${ACCOUNT_ID}" \
  --project-id="${PROJECT_ID}" \
  --notifyID="${NOTIFY_ID}" \
  --api-key="${API_KEY}" \
  --file-name hce-api.sh | jq -r '.data.resiliencyScore')

echo "[Result]: Actual Resiliency Score = ${RESILIENCY_SCORE}"
echo "[Expected]: Expected Resiliency Score = ${EXPECTED_RESILIENCE_SCORE}"

if (( $(echo "$RESILIENCY_SCORE >= $EXPECTED_RESILIENCE_SCORE" | bc -l) )); then
  echo "[Success]: Resiliency Score meets the expectation."
else
  echo "[Failure]: Resiliency Score is below expected threshold."
  exit 1
fi
