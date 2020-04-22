#! /usr/bin/env bash

function run() {
  ./run.sh
}

function config() {
  if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN missing from environment."
    exit 1
  fi

  if [ -z "$GITHUB_RUNNER_URL" ]; then
    echo "GITHUB_RUNNER_URL missing from environment."
    exit 1
  fi

  IS_ORG_RUNNER=0
  OWNER=$(echo $GITHUB_RUNNER_URL | sed -n 's/https:\/\/github.com\/\([^/]*\)\/\([^/]*\).*/\1/p')
  REPO=$(echo $GITHUB_RUNNER_URL | sed -n 's/https:\/\/github.com\/\([^/]*\)\/\([^/]*\).*/\2/p')

  if [ -z "$REPO" ]; then
    IS_ORG_RUNNER=1
    OWNER=$(echo $GITHUB_RUNNER_URL | sed -n 's/https:\/\/github.com\/\([^/]*\).*/\1/p')

    if [ -z "$OWNER" ]; then
      echo "GITHUB_RUNNER_URL is malformed."
      exit 1
    fi
  fi

  echo $OWNER/$REPO

  if [ "$IS_ORG_RUNNER" -eq "0" ]; then
    RUNNER_REGISTRATION_URL="https://api.github.com/repos/$OWNER/$REPO/actions/runners/registration-token"
  else
    RUNNER_REGISTRATION_URL="https://api.github.com/orgs/$OWNER/actions/runners/registration-token"
  fi

  GITHUB_RUNNER_TOKEN=$(curl --request POST --header "Authorization: Bearer ${GITHUB_TOKEN}" $RUNNER_REGISTRATION_URL | jq '.token' | tr -d \")

  if [ "$GITHUB_RUNNER_TOKEN" = "null" ]; then
    echo "An error occurred when creating a registration token."
    exit 1
  fi

  if [ -z "$GITHUB_RUNNER_NAME" ]; then
    RNG=$(openssl rand -hex 3)
    GITHUB_RUNNER_NAME="gh-runner-$RNG"
  fi

  if [ -z "$GITHUB_RUNNER_WORKDIR" ]; then
    GITHUB_RUNNER_WORKDIR=./_work
  fi

  ./config.sh --url $GITHUB_RUNNER_URL --token $GITHUB_RUNNER_TOKEN --name $GITHUB_RUNNER_NAME --work $GITHUB_RUNNER_WORKDIR
}

case $1 in
  config)
    config
    ;;
  
  run)
    run
    ;;
  
  *)
    config
    run
    ;;
esac
