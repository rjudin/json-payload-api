# Requirements:
- Endpoint accepting JSON payloads with the following attributes: name, email, message
- Data should be stored using one of persistent storage solutions provided by AWS
- SNS event should be dispatched once the data has been stored

# Architecture:
## Option 1
POST request with json payload in the 'body' -> AWS API GW -> Lambda Function-> DynamoDB or S3 persistent -> SNS event (after success)
- dealing with escape character json->string during api gw to lambda [4]

## Option 2
POST request with json payload in the 'body' -> AWS API GW -> DynamoDB or S3 persistent -> SNS event (after success)
- implement peristsent mapping to dynamodb (optional DynamoDB Streaming) without Lambda in the middle

## Resources:
1. [API GW + Lambda + DynamoDB](https://docs.aws.amazon.com/lambda/latest/dg/with-on-demand-https-example.html)
2. [API GW proxy directly into DynamoDB](https://aws.amazon.com/blogs/compute/using-amazon-api-gateway-as-a-proxy-for-dynamodb/)
3. [PluralSight: Scalable API GW](https://app.pluralsight.com/library/courses/scalable-aws-api-gateway/)
4. [Lambda Integration vs Lambda Proxy Integration](https://stackoverflow.com/a/52240132)
