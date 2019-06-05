#!/bin/bash
Action=$1

StackNAME=AIO
AWSregion=eu-west-1

function wait_creation(){
  for attempt in {1..20}; do
      StackStatus=$(aws --region=$AWSregion cloudformation describe-stacks --stack-name $StackNAME | jq -C '.Stacks[].StackStatus' -r)
  if [ $StackStatus == "CREATE_COMPLETE" ]; then
      return 0
  elif [ $StackStatus == "CREATE_IN_PROGRESS" ]; then
      printf "\nAttempt: "; printf %02d "$attempt"; printf " | StackStatus: $StackStatus\n"
  elif [[ $StackStatus == *"FAILED"* ]] || \
       [[ $StackStatus == *"DELETE"* ]]; then
      echo -e "\n\n$(date "+%Y-%m-%d %H:%M:%S") Stack creation $StackStatus. Stop sequence\n\n"
      exit 400
  else
    echo -e "\n\n$(date "+%Y-%m-%d %H:%M:%S") Waiting for $StackNAME creation took to long. Current stack status : $StackStatus\n\n"
    exit 504
  fi
      sleep 5
  done
}

function create_stack(){
  echo "Processing creation $StackNAME$"
  aws --region=$AWSregion cloudformation create-stack \
      --stack-name $StackNAME --parameters file://$StackNAME.json \
      --capabilities CAPABILITY_IAM \
      --disable-rollback \
      --template-body file://template.yaml && wait_creation
}

function update_stack(){
  aws --region=$AWSregion cloudformation update-stack \
      --stack-name $StackNAME --parameters file://$StackNAME.json  \
      --capabilities CAPABILITY_IAM \
      --template-body file://template.yaml

  echo "$StackNAME: wait for stack-update-complete"
  aws --region=$AWSregion cloudformation \
      wait stack-update-complete --stack-name $StackNAME
}

function get_stack(){
  aws --region=$AWSregion cloudformation \
      list-stack-resources --stack-name $StackNAME
}

function delete_stack(){
  aws --region=$AWSregion cloudformation \
      delete-stack --stack-name $StackNAME
}

function output_for_user(){
  echo "";
  echo "Important information for start it working:"
  aws --region=$AWSregion cloudformation list-exports | jq '.Exports[].Value' -r
}

case $Action in
  ("create") echo "create action";  create_stack && output_for_user  ;;
  ("update") echo "apply action";   update_stack && output_for_user  ;;
  ("get") echo "get action";        get_stack    && output_for_user  ;;
  ("delete") echo "delete action";  delete_stack                     ;;
  *) echo "Required action: create | update | get | delete" ;;
esac;
