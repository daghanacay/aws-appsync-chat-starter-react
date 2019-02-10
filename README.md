# ChatQLv2: An AWS AppSync Chat Starter App written in React

This is a fork from https://github.com/aws-samples/aws-appsync-chat-starter-react

## Quicklinks

- re:Invent 2018 [Session](https://www.youtube.com/watch?v=0H5F0PI2-SU)/[Slides](https://www.slideshare.net/AmazonWebServices/bridging-the-gap-between-real-timeoffline-and-aiml-capabilities-in-modern-serverless-apps-mob310-aws-reinvent-2018)
- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)

## Introduction

This is a Starter React Progressive Web Application (PWA) that uses AWS AppSync to implement offline and real-time capabilities in a chat application with AI/ML features such as image recognition, text-to-speech, language translation, sentiment analysis as well as conversational chatbots developed as part of the re:Invent session [Bridging the Gap Between Real Time/Offline and AI/ML Capabilities in Modern Serverless Apps](https://www.youtube.com/watch?v=0H5F0PI2-SU). In the chat app, users can search for users and messages, have conversations with other users, upload images and exchange messages. The application demonstrates GraphQL Mutations, Queries and Subscriptions with AWS AppSync integrating with other AWS Services:

![ChatQL Overview](/media/ChatQLv2.png)

- Amazon Cognito for user management as well as AuthN/Z
- Amazon DynamoDB with 4x NoSQL Data Sources (Users, Messages, Conversations, ConvoLink)
- Amazon Elasticsearch Data Source for full text search on messages and users
- AWS Lambda as a Serverless Data Source connecting to AI Services
- Amazon Comprehend for sentiment and entity analysis as well as language detection
- Amazon Rekognition for object, scene and celebrity detection on images
- Amazon Lex for conversational chatbots
- Amazon Polly for text-to-speech on messages
- Amazon Translate for language translation
- Amazon S3 for Media Storage

You can use this for learning purposes or adapt either the application or the GraphQL Schema to meet your needs.

## Getting Started

### Prerequisites

- [AWS Account](https://aws.amazon.com/mobile/details) with appropriate permissions to create the related resources
- [NodeJS](https://nodejs.org/en/download/) with [NPM](https://docs.npmjs.com/getting-started/installing-node)
- [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) with output configured as JSON `(pip install awscli --upgrade --user)`
- [AWS Amplify CLI](https://github.com/aws-amplify/amplify-cli) configured for a region where [AWS AppSync](https://docs.aws.amazon.com/general/latest/gr/rande.html) and all other services in use are available `(npm install -g @aws-amplify/cli)`
- [AWS SAM CLI](https://github.com/awslabs/aws-sam-cli) `(pip install --user aws-sam-cli)`
- [Create React App](https://github.com/facebook/create-react-app) `(npm install -g create-react-app)`
- [Install JQ](https://stedolan.github.io/jq/)
- If using Windows, you'll need the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)


# Step 1 Create backend

- Before you start you set up AWS cli to us-east-1
- Init the directory as an amplify **Javascript** app using the **React** framework:

   ```bash
   amplify init
   ```

here are the selected options in the order the cli asked

Enter name of project -> chatbot  
Choose your default editor? -> Visal Studio Code (or your own editor from the list)  
Choose the type of app that you're building? -> javascript  
What javascript framework are you using? -> react  
Source Directory Path? -> leave default press enter  
Distribution Directory Path: -> leave default press enter  
Build Command: -> leave default press enter  
Start Command: -> leave default press enter  

Do you want to use an AWS profile? -> yes  
Please choose the profile you want to use -> default  

Wait until the project initializes. It takes 1 to 3 minutes

- Set the region we are deploying resources to:

   ```bash
   export AWS_REGION=$(jq -r '.providers.awscloudformation.Region' amplify/#current-cloud-backend/amplify-meta.json)
   echo $AWS_REGION
   ```

WARNING if echo result is not us-east-1 please set up your default profile to us-east-1 or use one that is pointing to us-east-1 and repeat the process above. Otherwise, you'll get errors in the next steps.

- Add an **Amazon Cognito User Pool** auth resource. Use the default configuration.

   ```bash
   amplify add auth
   ```
Do you want to use the default authentication and security configuration? -> Yes, use the default configuration.

- Add an **AppSync GraphQL** API with **Amazon Cognito User Pool** for the API Authentication. Follow the default options. When prompted with "_Do you have an annotated GraphQL schema?_", select **"YES"** and provide the schema file path `backend/schema.graphql`

   ```bash
   amplify add api
   ```

   Please select from one of the below mentioned services -> GraphQL  
   Provide API name: -> chatappApi  
   Choose an authorization type for the API -> Amazon Cognito User Pool  
   Do you have an annotated GraphQL schema? -> Y  
   Provide your schema file path: -> backend/schema.graphql  

- Add S3 Private Storage for **Content** to the project with the default options. Select private **read/write** access for **Auth users only**:

   ```bash
   amplify add storage
   ```

   Please select from one of the below mentioned services -> Content (Images, audio, video, etc.)  
   Please provide a friendly name for your resource that will be used to label this category in the project: -> chatappContent  
   Please provide bucket name: -> select default press enter  
   Who should have access: -> Auth users only  
   What kind of access do you want for Authenticated users -> read/write  
  

- Now it's time to provision your cloud resources based on the local setup and configured features. When asked to generate code, answer **"YES"**. We will overwrite the src later. Important that you choose **javascript** as source language.

   ```bash
   amplify push
   ```

   Are you sure you want to continue? -> Yes  
   Do you want to generate code for your newly created GraphQL API (Y/n) -> yes  
   Choose the code generation language target -> javascript  
   Enter the file name pattern of graphql queries, mutations and subscriptions -> select default press enter  
   Do you want to generate/update all possible GraphQL operations - queries, mutations and subscriptions -> y  


   Wait for the provisioning to complete, this will take 3 to 5 mins. Once done, a `src/aws-exports.js` file is created with the resources information. Also, go and see the following service in your AWS console 

   - Cloud formation
   - AppSync
   - Dynamo
   - Elasticsearch
   - S3
   - IAM roles
   - Cognito

Meanwhile, check your loca folders. You need to have 

```
.
├── amplify
│   ├── backend
│   │   ├── amplify-meta.json
│   │   ├── api
│   │   │   └── chatappApi
│   │   ├── auth
│   │   │   └── cognitoe60ac89f
│   │   ├── awscloudformation
│   │   │   └── nested-cloudformation-stack.yml
│   │   └── storage
│   │       └── chatappContent
│   └── #current-cloud-backend
├── backend
│   └── schema.graphql
└── src
    ├── aws-exports.js
    └── graphql
        ├── mutations.js
        ├── queries.js
        ├── schema.json
        └── subscriptions.js
```

   Spend some time to reconsile the above resources with `src/aws-exports.js` also check the resolvers that are generated for you in AppSync. Also check the `src/graphql` folder in your local to see the client side libraries for graphql we will use in the next step. Pay attention to query, mutation, model, and subscription entries.