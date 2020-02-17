#!/bin/bash

echo "TEMPLATE_URI=$TEMPLATE_URI"

CMD_GET_LOGIN="aws ecr get-login --no-include-email --region us-east-1"
echo $CMD_GET_LOGIN

CMD_LOGIN=`$CMD_GET_LOGIN`
echo $CMD_LOGIN
$CMD_LOGIN

CMD_TAG="docker tag laravel-app:latest $URI:latest"
echo $CMD_TAG
$CMD_TAG

CMD_PUSH="docker push $URI:latest"
echo $CMD_PUSH
$CMD_PUSH
