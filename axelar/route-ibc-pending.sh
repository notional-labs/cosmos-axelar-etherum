#!/usr/bin/env bash

NODE_HOME=testnet/axelar-testnet
CHAIN_ID=axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home $NODE_HOME"
BINARY="_build/binary/axelard"
CUDOS_BINARY="_build/binary/cudos-noded"
EVM_CHAIN=ethereum

export NODE_HOME
export CHAIN_ID
export DEFAULT_KEYS_FLAGS
export BINARY

TX_SEND=$(jq -r '.tx' testnet/evm-testnet/token-send/tx.json)

echo "tx send: $TX_SEND"

echo "#### 1. Verify transaction ####"
sh ./axelar/steps/verify-gateway-txn.sh "${EVM_CHAIN}" "${TX_SEND}"

sleep 5
echo "#### 2. verify transactions included in block ####"



echo "#### 3. Send IBC ####"
$BINARY tx axelarnet route-ibc-transfers --from gov1 --keyring-backend test --home ${NODE_HOME}

sleep 10
echo "#### 4. Verify received tokens on Cudos ####"
$CUDOS_BINARY q bank balances cudos1mjk79fjjgpplak5wq838w0yd982gzkyfz8xprw --node http://localhost:16657
