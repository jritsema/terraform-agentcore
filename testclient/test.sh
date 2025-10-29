#!/bin/bash
set -e

# get agentcore runtime arn from terraform
cd ..
export AGENTCORE_RUNTIME_ARN=$(terraform output -raw agentcore_runtime_arn)
cd -

# execute python test script and pass in runtime arn
python -u main.py --agent-runtime-arn $AGENTCORE_RUNTIME_ARN --prompt "$1"
