# Step 2 Create react app

At this stage we can create our fronte end. you can start with 

- create-react-app test
- cp -rf ./test/* .; rm -rf test
- npm start

go change the src/App.js and make changes and see how the browser updates. Once you are happy with the fornt end code, replace it with the bot code.

- cp -rf ./front-end/* .
- npm install
- npm start

It will take some time to compile. If the load finishes and you see an empty browser then refresh the page. you should see a login window.

## Login to chat screen

go to localhost:3000

- Signing with your email and mobile number
- If you do not receive confirmation login to your AWS console and in Cognito -> User Pools -> Users and groups, find yourself and click on the email and confirm user
- in chatbot go back to your login page and login
- create two users so you have someone to talk to on your local :)
- Search for new users to start a conversation and test real-time/offline messaging as well as other features using different devices or browsers.

WARNING at this stage dropdown from chatbot is not working since we have not deployed the AI backend yet. for that we need to go to the next step.

please checkout next step
