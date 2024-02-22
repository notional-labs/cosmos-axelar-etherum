#!/bin/bash

CHAIN=$1
GATEWAY=$2

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

if [ -z "$GATEWAY" ]
then
  echo "Gateway is required"
  exit 1
fi

echo "Setting gateway: $GATEWAY"
echo "CHain $CHAIN"
$BINARY tx evm set-gateway ${CHAIN} ${GATEWAY} --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${NODE_HOME} \
--output json --gas 500000 &> ${NODE_HOME}/unsigned_msg.json

cat ${NODE_HOME}/unsigned_msg.json

sh ./axelar/bin/libs/broadcast-unsigned-multi-tx.sh

