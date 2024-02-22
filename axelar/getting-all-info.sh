#!/bin/bash

NODE_HOME=testnet/axelar-testnet
CHAIN_ID=axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home $NODE_HOME"
BINARY="_build/binary/axelard"

export NODE_HOME
export CHAIN_ID
export DEFAULT_KEYS_FLAGS
export BINARY

COSMOS_CHAIN=$1
EVM_CHAIN=$2

if [ -z "$COSMOS_CHAIN" ] || [ -z "$EVM_CHAIN" ]
then
  echo "COSMOS_CHAIN EVM_CHAIN are required"
  exit 1
fi

# Gán kết quả của lệnh docker exec vào biến RESULT
OWNER_VAL_ADDRESS=$($BINARY keys show owner -a --bech val ${DEFAULT_KEYS_FLAGS})
OWNER_ADDRESS=$($BINARY keys show owner ${DEFAULT_KEYS_FLAGS})

# In ra giá trị của biến RESULT
echo "owner validator address: $OWNER_VAL_ADDRESS"
echo "owner address: $OWNER_ADDRESS"

SUPPORTED_CHAINS=$($BINARY q nexus chains)
echo "Supported chains: $SUPPORTED_CHAINS"

ETHEREUM_CHAINS=$($BINARY q nexus assets "${EVM_CHAIN}")
echo "Ethereum chain assets: $ETHEREUM_CHAINS"

echo "Cosmos chain assets: $($BINARY q nexus assets "${COSMOS_CHAIN}")"


#sh "$DIR/06-setgateway.sh $1 $2"






