# AWS Cognito lab

We're following this [lab](https://github.com/acantril/learn-cantrill-io-labs/tree/master/aws-cognito-web-identity-federation) but instead of doing everything via cloudformation and the console, we're doing everything through terraform.

If you build your own, you'll need to [register an app in google](https://github.com/acantril/learn-cantrill-io-labs/blob/master/aws-cognito-web-identity-federation/02_LABINSTRUCTIONS/STAGE2%20-%20Create%20Google%20APIProject%20and%20Client%20ID.md) and remember the client_id.

If you run it and it works, it'll show you pictures of cats.

I had a lot of learning making this. I forgot to:

 * Make my roles trust the cognito
 * Make the private bucket have a CORS rules
 * Among other things

I made this for myself so I could learn.