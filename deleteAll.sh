#!/bin/bash
# delete Lex bots
aws lex-models delete-bot --name `jq -r .name backend/ChuckBot/bot.json` --region $AWS_REGION
aws lex-models delete-bot --name `jq -r .name backend/MovieBot/bot.json` --region $AWS_REGION
aws lex-models delete-intent --name `jq -r .name backend/ChuckBot/intent.json` --region $AWS_REGION
aws lex-models delete-intent --name `jq -r .name backend/MovieBot/intent.json` --region $AWS_REGION
aws lex-models delete-slot-type --name `jq -r .name backend/ChuckBot/slot-type.json` --region $AWS_REGION
aws lex-models delete-slot-type --name `jq -r .name backend/MovieBot/slot-type.json` --region $AWS_REGION
#Delete bot lambdas
aws cloudformation delete-stack --stack-name $STACK_NAME_AIML --region $AWS_REGION

#Delete delete the resources created by the Amplify CLI.

amplify delete