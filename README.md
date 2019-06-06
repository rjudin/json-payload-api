# Requirements:
- Endpoint accepting JSON payloads with the following attributes: name, email, message
- Data should be stored using one of persistent storage solutions provided by AWS
- SNS event should be dispatched once the data has been stored

# Architecture:
POST request with json payload in the 'body' -> AWS API GW -> DynamoDB Stream-> Lambda -> SNS event (email)

Pros: implement persistent mapping to dynamodb without Lambda in the middle

# Implementation

## Script Usage
Script will require you to have: `bash, awscli, jq`

Parameter file `AIO.json` have to be exist in root directory:
```json
[
  {
    "ParameterKey": "SNSEndpoint",
    "ParameterValue": "your@gmail.com"
  }
]
```

- get all possible actions
```
./provision.sh
```
>Required action: create | update | get | delete

- create new stack
```
./provision.sh create
```
- update existing stack
```
./provision.sh update
```
- get/list existing stack
```
./provision.sh get
```
- delete/terminate existing stack
```
./provision.sh delete
```

**After `create`, `update` and `get` actions you will receive 'Important information..' - notification that endpoint need to be confirmed and curl query for testing expected functionality**

## CloudFormation Usage
1. Go to [CloudFormation console](https://console.aws.amazon.com/cloudformation)
2. Create stack based on file `template.yaml`
3. Check Output section once stack has been created

## Resources:
1. [API GW + Lambda + DynamoDB](https://docs.aws.amazon.com/lambda/latest/dg/with-on-demand-https-example.html)
2. [API GW proxy directly into DynamoDB](https://aws.amazon.com/blogs/compute/using-amazon-api-gateway-as-a-proxy-for-dynamodb/)
3. [PluralSight: Scalable API GW](https://app.pluralsight.com/library/courses/scalable-aws-api-gateway/)
4. [Lambda Integration vs Lambda Proxy Integration](https://stackoverflow.com/a/52240132)
