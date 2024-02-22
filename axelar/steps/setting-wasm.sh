#!/bin/bash

CHAIN_ID=wasm
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
CHAIN=$1
GATEWAY=$2
DIR="$(dirname "$0")"

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

# Gán kết quả của lệnh docker exec vào biến RESULT
OWNER_VAL_ADDRESS=$(axelard keys show owner -a --bech val ${DEFAULT_KEYS_FLAGS})
OWNER_ADDRESS=$(axelard keys show owner ${DEFAULT_KEYS_FLAGS})

# In ra giá trị của biến RESULT
echo "owner validator address: $OWNER_VAL_ADDRESS"
echo "owner address: $OWNER_ADDRESS"

#sh "$DIR/06-setgateway.sh $1 $2"






