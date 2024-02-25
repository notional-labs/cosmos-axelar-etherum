#!/bin/bash

EVM_CHAIN=$1
ORIGIN_CHAIN=$2
ORIGIN_ASSET=$3
DEPLOY_TOKEN_TX_HASH=$4

if [ -z "$EVM_CHAIN" ] || [ -z "$ORIGIN_CHAIN" ] || [ -z "$ORIGIN_ASSET" ] || [ -z "$DEPLOY_TOKEN_TX_HASH" ]
then
  echo "EVM_CHAIN ORIGIN_CHAIN  ORIGIN_ASSET  TOKEN_NAME  DEPLOY_TOKEN_TX_HASH are required"
  exit 1
fi

$BINARY tx evm confirm-erc20-token "${EVM_CHAIN}" "${ORIGIN_CHAIN}" "${ORIGIN_ASSET}" "${DEPLOY_TOKEN_TX_HASH}"  --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${NODE_HOME} \
--output json --gas 500000 &> ${NODE_HOME}/unsigned_msg.json
cat ${NODE_HOME}/unsigned_msg.json
#echo "Registered asset ${CHAIN} ${DENOM}"

sh ./axelar/bin/libs/broadcast-unsigned-multi-tx.sh
