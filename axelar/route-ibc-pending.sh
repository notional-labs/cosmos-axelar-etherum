#!/usr/bin/env bash

NODE_HOME=testnet/axelar-testnet
CHAIN_ID=axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home $NODE_HOME"
BINARY="_build/binary/axelard"
EVM_CHAIN=ethereum

export NODE_HOME
export CHAIN_ID
export DEFAULT_KEYS_FLAGS
export BINARY

TX_SEND=$(jq -r '.tx' testnet/evm-testnet/token-send/tx.json)

echo "tx send: $TX_SEND"

echo "#### 1. Verify transaction ####"
sh ./axelar/steps/verify-gateway-txn.sh "${EVM_CHAIN}" "${TX_SEND}"

# get the destination address


sleep 5
echo "#### 2. Send IBC ####"
$BINARY tx axelarnet route-ibc-transfers --from gov1 --keyring-backend test --home ${NODE_HOME}