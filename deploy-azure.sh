#!/bin/bash

TENANT=a5f80a38-f3e4-4756-9298-c016d9e89da4
SUBSCRIPTION=b08e763f-d77e-48ab-b59c-1077af779a5c
NAME_OF_REGISTRY=crdokanalyse
APP_NAME=dokanalyse-pygeoapi
APP_VERSION=$(date '+%Y%m%d')

az login --tenant ${TENANT} --use-device-code
az acr login -n ${NAME_OF_REGISTRY}

docker build -t ${APP_NAME}:${APP_VERSION} --no-cache .
docker tag ${APP_NAME}:${APP_VERSION} ${NAME_OF_REGISTRY}.azurecr.io/${APP_NAME}:${APP_VERSION}
docker push ${NAME_OF_REGISTRY}.azurecr.io/${APP_NAME}:${APP_VERSION}
