#!/bin/sh

EVM_CHAIN=ethereum

## For Testing chain
COSMOS_CHAIN=cudos
COSMOS_DENOM=acudos
AXELAR_CHAIN=axelarnet
EVM_DENOM=uusdc
DIR="$(dirname "$0")"

NODE_HOME=testnet/axelar-testnet
CHAIN_ID=axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home $NODE_HOME"
BINARY="_build/binary/axelard"

export $NODE_HOME
export $CHAIN_ID
export $DEFAULT_KEYS_FLAGS
export $BINARY

GATEWAY_ID=$(jq -r '.[0].gateway' testnet/evm-testnet/chain-config/local-evm.json)
TOKEN_ADDRESS=$(jq -r '.[0].tokenDeployAddress' testnet/evm-testnet/chain-config/local-evm.json)
TX_HASH=$(jq -r '.[0].tokenDeployTxHash' testnet/evm-testnet/chain-config/local-evm.json)

echo "#### 1. Adding EVM chain ####"
sh "${DIR}/steps/01-add-evm-chain.sh" ${EVM_CHAIN}

echo "\n#### 2. Adding Cosmos chain ####"
sh "${DIR}/steps/02-add-cosmos-chain.sh" ${COSMOS_CHAIN}

echo "\n#### 3. Register Broadcaster ####"
sh "${DIR}/steps/03-register-broadcaster.sh"

echo "\n#### 4. Activate EVM Chains ####"
sh "${DIR}/steps/04-activate-evm-chain.sh" ${EVM_CHAIN}

echo "\n#### 5. Activate Cosmos Chains ####"
sh "${DIR}/steps/05-activate-cosmos-chain.sh" ${COSMOS_CHAIN}

echo "\n#### 6. Register Cosmos native asset ####"
sh "${DIR}/steps/09-register-native-asset.sh" ${COSMOS_CHAIN} ${COSMOS_DENOM}

echo "\n#### 7. Set gateway id ####"
sh "${DIR}/steps/06-setgateway.sh" ${EVM_CHAIN} ${GATEWAY_ID}

echo "\n#### 8. Register new token to Ethereum ####"
sh "${DIR}/steps/07-create-deploy-token.sh" ${TOKEN_ADDRESS}

echo "\n#### 9. Confirm deploy token ####"
sh "${DIR}/steps/08-confirm-deploy-token.sh" ${TX_HASH}

echo "\n#### 10. Register Cosmos support aUSDC asset ####"
sh "${DIR}/steps/foregin-asset.sh" ${COSMOS_CHAIN} ${EVM_DENOM}

echo "\n#### 11. Register Axelar support aUSDC asset ####"
sh "${DIR}/steps/foregin-asset.sh" ${AXELAR_CHAIN} ${EVM_DENOM}

