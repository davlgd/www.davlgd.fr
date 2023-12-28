#!/bin/bash

DOMAIN="www.davlgd.fr"
BUCKET="davlgd/${DOMAIN}"
DEPLOY_COMMAND="mc cp -r src/ ${BUCKET}"
DEPLOY_MESSAGE="Website content deployment on Cellar :"

if ! command -v mc &> /dev/null; then
    printf "\e[31m✗\e[0m The 'mc' command is not installed or not accessible from the $PATH.\n"
    exit 1
fi

if ! mc ls "${BUCKET}" &> /dev/null; then
    printf "\e[31m✗\e[0m The bucket '%s' does not exist or has a problem.\n" "${BUCKET}"
    exit 1
fi

if ${DEPLOY_COMMAND[@]} > /dev/null; then
    printf "%s \e[32m✓\e[0m\n" "${DEPLOY_MESSAGE}"
    printf "You can access it: https://%s\n" "${DOMAIN}"
else
    printf "%s \e[31m✗\e[0m\n" "${DEPLOY_MESSAGE}"
fi
