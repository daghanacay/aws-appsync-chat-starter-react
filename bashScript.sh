#!/bin/bash
# Look up the S3 bucket name created for user storage:
export USER_FILES_BUCKET=$(sed -n 's/.*"aws_user_files_s3_bucket": "\(.*\)".*/\1/p' src/aws-exports.js)
echo "user files bucket: $USER_FILES_BUCKET"
# Retrieve the API ID of your AppSync GraphQL endpoint
export GRAPHQL_API_ID=$(jq -r '.api[(.api | keys)[0]].output.GraphQLAPIIdOutput' ./amplify/#current-cloud-backend/amplify-meta.json)
echo "Graphql App ID: $GRAPHQL_API_ID"
# Retrieve the project's deployment bucket and stackname . It will be used for packaging and deployment with SAM
export DEPLOYMENT_BUCKET_NAME=$(jq -r '.providers.awscloudformation.DeploymentBucketName' ./amplify/#current-cloud-backend/amplify-meta.json)
export STACK_NAME=$(jq -r '.providers.awscloudformation.StackName' ./amplify/#current-cloud-backend/amplify-meta.json)
echo "Deployment bucket name $DEPLOYMENT_BUCKET_NAME"
echo "Stack name: $STACK_NAME"
# Set the region we are deploying resources to
export AWS_REGION=$(jq -r '.providers.awscloudformation.Region' amplify/#current-cloud-backend/amplify-meta.json)
echo "AWS region: $AWS_REGION"
