# Step 1 

- create a folder called chatapp-workshop and go inside the folder

   ```
   mkdir chatapp-workshop   
   cd chatapp-workshop   
   ```

- Init the directory as an amplify **Javascript** app using the **React** framework:

   ```bash
   amplify init
   ```

here are the selected options in the order the cli asked
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

   Make sure [**ALL**](https://docs.aws.amazon.com/general/latest/gr/rande.html) services are supported in this region or else you'll get errors in the next steps.

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


   Wait for the provisioning to complete, this will take 3 to 5 mins. Once done, a `src/aws-exports.js` file with the resources information is created. Also go and see the following service in your AWS console 

   - Cloud formation
   - AppSync
   - Dynamo
   - Elasticsearch
   - S3
   - IAM roles
   - Cognito

   Spend some time to reconsile the above resources with `src/aws-exports.js` also check the resolvers that are generated for you in AppSync. Also check the `src/graphql` folder in your local to see the client side libraries for graphql we will use in the next step. Pay attention to query, mutation, model, and subscription entries.