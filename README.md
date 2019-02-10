# Introduction

At this point you have an usable serverless chat application with no AI features. The next steps are only needed to deploy and configure the integration with services that provide image recognition, text-to-speech, language translation, sentiment analysis as well as conversational chatbots.

# Step 3 - AI and chatbots

- Give the bash script execution and run it


   ```bash
   chmod +x bashScript.sh
   . bashScript.sh
   ```

This script will 
- Look up the S3 bucket name created for user storage
- Retrieve the API ID of your AppSync GraphQL endpoint
- Retrieve the project's deployment bucket and stackname . It will be used for packaging and deployment with SAM
- Set the region we are deploying resources to

Now we need to deploy 3 Lambda functions (one for AppSync and two for Lex) and configure the AppSync Resolvers to use Lambda accordingly. First, we install the npm dependencies for each lambda function. We then package and deploy the changes with SAM.

    ```bash
    cd ./backend/chuckbot-lambda; npm install; cd ../..
    cd ./backend/moviebot-lambda; npm install; cd ../..
    sam package --template-file ./backend/deploy.yaml --s3-bucket $DEPLOYMENT_BUCKET_NAME --output-template-file packaged.yaml
    export STACK_NAME_AIML="$STACK_NAME-extra-aiml"
    sam deploy --template-file ./packaged.yaml --stack-name $STACK_NAME_AIML --capabilities CAPABILITY_IAM --parameter-overrides appSyncAPI=$GRAPHQL_API_ID s3Bucket=$USER_FILES_BUCKET --region $AWS_REGION
    ```

    Wait for the stack to finish deploying. At this point login to your console and go to Lambda. See two lambda functions are installed for you.
    
    Now run the next script to  
     - retrieve the functions' ARN.
     - add permissions so Lex can invoke the chatbot related functions
     - update the bots intents with the Lambda ARN
     - And, deploy the slot types, intents and bots

    ```bash
    . lexBash.sh
    ```

- Finally, execute the following command to install your project package dependencies and run the application locally:

    ```bash
    amplify serve
    ```

- Access your ChatQLv2 app at http://localhost:3000. This time you can access AI capabilities of your bot

### Interacting with Chatbots

_The chatbots retrieve information online via API calls from Lambda to [The Movie Database (TMDb)](https://www.themoviedb.org/) (MovieBot, which is based on this [chatbot sample](https://github.com/aws-samples/aws-lex-convo-bot-example)) and [chucknorris.io ](https://api.chucknorris.io/) (ChuckBot)_

1. In order to initiate or respond to a chatbot conversation, you need to start the message with either `@chuckbot` or `@moviebot` to trigger or respond to the specific bot, for example:

   - _@chuckbot Give me a Chuck Norris fact_
   - _@moviebot Tell me about a movie_

2. Each subsequent response needs to start with the bot handle (@chuckbot or @moviebot) so the app can detect the message is directed to Lex and not to the other user in the same conversation. Both users will be able to view Lex chatbot responses in real-time powered by GraphQL subscriptions.
3. Alternatively you can start a chatbot conversation from the message drop-down menu:

   - Just selecting `ChuckBot` will display options for further interaction
   - Send a message with a nothing but a movie name and selecting `MovieBot` subsequently will retrieve the details about the movie

### Interacting with other AWS AI Services

1. Click or select uploaded images to trigger Amazon Rekognition object, scene and celebrity detection. You can use the Chuck Norris image inside "images folder"
2. From the drop-down menu, select LISTEN -> TEXT TO SPEECH to trigger Amazon Polly and listen to messages in different voices based on the message automatically detected source language (supported languages: English, Mandarin, Portuguese, French and Spanish).
3. To perform entity and sentiment analysis on messages via Amazon Comprehend, select ANALYZE -> SENTIMENT from the drop-down menu.
4. To translate the message select the desired language under TRANSLATE in the drop-down menu (supported languages: English, Mandarin, Portuguese, French and Spanish). In the translation pane, click on the microphone icon to listen to the translated message.

## Building, Deploying and Publishing with the Amplify CLI

1. Execute `amplify add hosting` from the project's root folder and follow the prompts to create an S3 bucket (DEV) and/or a CloudFront distribution (PROD). WARNING you have to choose PROD-cloudfront option to use PWA functionality on the phone.

2. Build, deploy, upload and publish the application with a single command:

   ```bash
   amplify publish
   ```
This will take 5 to 10 minutes depending on the selection you made. 

3. If you are deploying a CloudFront distribution, be mindful it needs to be replicated across all points of presence globally and it might take up to 15 minutes to do so.

4. Access your public ChatQL application using the S3 Website Endpoint URL or the CloudFront URL returned by the `amplify publish` command. Share the link with friends, sign up some users, and start creating conversations, uploading images, translating, executing text-to-speech in different languages, performing sentiment analysis and exchanging messages. Be mindful PWAs require SSL, in order to test PWA functionality access the CloudFront URL (HTTPS) from a mobile device and add the site to the mobile home screen.


## Clean Up

To clean up the project, you can simply delete the bots, delete the stack created by the SAM CLI:

```bash
. deleteAll.sh
```