#!/bin/bash
# get bot ARNS
export CHUCKBOT_FUNCTION_ARN=$(aws cloudformation describe-stacks --stack-name  $STACK_NAME_AIML --query "Stacks[0].Outputs" --region $AWS_REGION | jq -r '.[] | select(.OutputKey == "ChuckBotFunction") | .OutputValue')
export MOVIEBOT_FUNCTION_ARN=$(aws cloudformation describe-stacks --stack-name  $STACK_NAME_AIML --query "Stacks[0].Outputs" --region $AWS_REGION | jq -r '.[] | select(.OutputKey == "MovieBotFunction") | .OutputValue')
echo "chuckbot ARN: $CHUCKBOT_FUNCTION_ARN"
echo "Moviebot ARN: $MOVIEBOT_FUNCTION_ARN"
echo "Running permissions"
# Execute the following commands to add permissions so Lex can invoke the chatbot related functions
aws lambda add-permission --statement-id Lex --function-name $CHUCKBOT_FUNCTION_ARN --action lambda:\* --principal lex.amazonaws.com --region $AWS_REGION
aws lambda add-permission --statement-id Lex --function-name $MOVIEBOT_FUNCTION_ARN --action lambda:\* --principal lex.amazonaws.com --region $AWS_REGION
#Update the bots intents with the Lambda ARN:
jq '.fulfillmentActivity.codeHook.uri = $arn' --arg arn $CHUCKBOT_FUNCTION_ARN backend/ChuckBot/intent.json -M > tmp.txt ; cp tmp.txt backend/ChuckBot/intent.json; rm tmp.txt
jq '.fulfillmentActivity.codeHook.uri = $arn' --arg arn $MOVIEBOT_FUNCTION_ARN backend/MovieBot/intent.json -M > tmp.txt ; cp tmp.txt backend/MovieBot/intent.json; rm tmp.txt
#  And, deploy the slot types, intents and bots
echo "Adding lexbot"
aws lex-models put-slot-type --cli-input-json file://backend/ChuckBot/slot-type.json --region $AWS_REGION
aws lex-models put-intent --cli-input-json file://backend/ChuckBot/intent.json --region $AWS_REGION
aws lex-models put-bot --cli-input-json file://backend/ChuckBot/bot.json --region $AWS_REGION
aws lex-models put-slot-type --cli-input-json file://backend/MovieBot/slot-type.json --region $AWS_REGION
aws lex-models put-intent --cli-input-json file://backend/MovieBot/intent.json --region $AWS_REGION
aws lex-models put-bot --cli-input-json file://backend/MovieBot/bot.json --region $AWS_REGION