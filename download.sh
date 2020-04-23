#! /usr/bin/env bash

RUNNER_VERSION=$1
RUNNER_DOWNLOAD_URL=https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
GITHUB_TOKEN=$2

if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN missing from docker build arguments."
  exit 1
fi

if [ "${RUNNER_VERSION}" = "latest" ]; then
  RUNNER_DOWNLOAD_URL=$(curl --header "Authorization: Bearer ${GITHUB_TOKEN}" https://api.github.com/orgs/ActionsDesk/actions/runners/downloads | jq '.[]|select(.os == "linux")|select(.architecture == "x64")|.download_url' | tr -d \")
fi

echo "Downloading runner from $RUNNER_DOWNLOAD_URL"
curl --location --output ./actions-runner.tar.gz $RUNNER_DOWNLOAD_URL
