#!/bin/bash
EVM_CHAIN=$1
ORIGIN_CHAIN=$2
ORIGIN_ASSET=$3
TOKEN_NAME=$4
SYMBOL=$5
ADDRESS=$6

if [ -z "$EVM_CHAIN" ] || [ -z "$ORIGIN_CHAIN" ] || [ -z "$ORIGIN_ASSET" ] || [ -z "$TOKEN_NAME" ] || [ -z "$SYMBOL" ] || [ -z "$ADDRESS" ]
then
  echo "EVM_CHAIN ORIGIN_CHAIN  ORIGIN_ASSET  TOKEN_NAME  SYMBOL  ADDRESS are required"
  exit 1
fi

$BINARY tx evm create-deploy-token "${EVM_CHAIN}" "${ORIGIN_CHAIN}" "${ORIGIN_ASSET}" "${TOKEN_NAME}" "${SYMBOL}" 6 "0" 10000 --address "${ADDRESS}" --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${NODE_HOME} \
--output json --gas 500000 &> ${NODE_HOME}/unsigned_msg.json

cat ${NODE_HOME}/unsigned_msg.json

sh ./axelar/bin/libs/broadcast-unsigned-multi-tx.sh