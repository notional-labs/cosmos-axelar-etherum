#!/bin/sh

EVM_CHAIN=ethereum

## For Testing chain
COSMOS_CHAIN=cudos
COSMOS_DENOM=acudos
AXELAR_CHAIN=axelarnet

EVM_DENOM=uusdc
EVM_TOKEN_NAME="ethereum usdc"
EVM_TOKEN_SYMBOL=USDC
DIR="$(dirname "$0")"

NODE_HOME=testnet/axelar-testnet
CHAIN_ID=axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home $NODE_HOME"
BINARY="_build/binary/axelard"

export NODE_HOME
export CHAIN_ID
export DEFAULT_KEYS_FLAGS
export BINARY

GATEWAY_ID=$(jq -r '.[0].gateway' testnet/evm-testnet/chain-config/local-evm.json)
TOKEN_ADDRESS=$(jq -r '.[0].tokenDeployAddress' testnet/evm-testnet/chain-config/local-evm.json)
TX_HASH=$(jq -r '.[0].tokenDeployTxHash' testnet/evm-testnet/chain-config/local-evm.json)

echo "#### 1. Adding EVM chain ####"
sh "${DIR}/steps/add-evm-chain.sh" ${EVM_CHAIN}

echo "\n#### 2. Adding Cosmos chain ####"
sh "${DIR}/steps/add-cosmos-chain.sh" ${COSMOS_CHAIN}

echo "\n#### 3. Register Broadcaster ####"
sh "${DIR}/steps/register-broadcaster.sh"

echo "\n#### 4. Activate EVM Chains ####"
sh "${DIR}/steps/activate-evm-chain.sh" ${EVM_CHAIN}

echo "\n#### 5. Activate Cosmos Chains ####"
sh "${DIR}/steps/activate-cosmos-chain.sh" ${COSMOS_CHAIN}

echo "\n#### 6. Register Cosmos native asset ####"
sh "${DIR}/steps/register-native-asset.sh" ${COSMOS_CHAIN} ${COSMOS_DENOM}

echo "\n#### 7. Set gateway id ####"
sh "${DIR}/steps/setgateway.sh" ${EVM_CHAIN} "${GATEWAY_ID}"

echo "\n#### 8. Register new token to Ethereum ####"
sh "${DIR}/steps/create-deploy-token.sh" ${EVM_CHAIN} ${EVM_CHAIN} ${EVM_DENOM} "${EVM_TOKEN_NAME}" ${EVM_TOKEN_SYMBOL} "${TOKEN_ADDRESS}"

echo "\n#### 9. Confirm deploy token ####"
sh "${DIR}/steps/confirm-deploy-token.sh" ${EVM_CHAIN} ${EVM_CHAIN} ${EVM_DENOM} "${TX_HASH}"

echo "\n#### 10. Register Cosmos support aUSDC asset ####"
sh "${DIR}/steps/foregin-asset.sh" ${COSMOS_CHAIN} ${EVM_DENOM}

echo "\n#### 11. Register Axelar support aUSDC asset ####"
sh "${DIR}/steps/foregin-asset.sh" ${AXELAR_CHAIN} ${EVM_DENOM}

echo "\n#### 12. Getting all info after set up####"
sh "${DIR}/getting-all-info.sh" ${COSMOS_CHAIN} ${EVM_CHAIN}
