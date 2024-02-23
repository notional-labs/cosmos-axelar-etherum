#!/bin/bash

CHAIN=$1

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

if [ -z "$BINARY" ]
then
  echo "binary is required"
  exit 1
fi

$BINARY tx evm add-chain ${CHAIN} ./axelar/bin/libs/params.json --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${NODE_HOME} \
--output json --gas 500000 &> ${NODE_HOME}/unsigned_msg.json

sh ./axelar/bin/libs/broadcast-unsigned-multi-tx.sh

