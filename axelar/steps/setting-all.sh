#!/bin/bash

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
DIR="$(dirname "$0")"

# Gán kết quả của lệnh docker exec vào biến RESULT
OWNER_VAL_ADDRESS=$(axelard keys show owner -a --bech val ${DEFAULT_KEYS_FLAGS})
OWNER_ADDRESS=$(axelard keys show owner ${DEFAULT_KEYS_FLAGS})

# In ra giá trị của biến RESULT
echo "owner validator address: $OWNER_VAL_ADDRESS"
echo "owner address: $OWNER_ADDRESS"

#sh "$DIR/06-setgateway.sh $1 $2"






