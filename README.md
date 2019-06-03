#Requirements:
- Endpoint accepting JSON payloads with the following attributes: name, email, message
- Data should be stored using one of persistent storage solutions provided by AWS
- SNS event should be dispatched once the data has been stored

#Architecture:
## option 1
POST request with json payload in the 'body' -> AWS API GW -> Lambda Function-> DynamoDB or S3 persistent -> SNS event (after success)
- dealing with escape character json->string during api gw to lambda

## option 2
POST request with json payload in the 'body' -> AWS API GW -> DynamoDB or S3 persistent -> SNS event (after success)
- implement peristsent mapping to dynamodb (optional DynamoDB Streaming) without Lambda in the middle
