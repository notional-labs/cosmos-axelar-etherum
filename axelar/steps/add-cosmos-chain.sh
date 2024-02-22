#!/bin/bash

CHAIN=$1
CHANNEL_ID=${2:-channel-0}
DIR="$(dirname "$0")"

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

$BINARY tx axelarnet add-cosmos-based-chain ${CHAIN} ${CHAIN} transfer/${CHANNEL_ID} --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${NODE_HOME} \
--output json --gas 500000 &> ${NODE_HOME}/unsigned_msg.json
cat ${HOME}/unsigned_msg.json

sh ./axelar/bin/libs/broadcast-unsigned-multi-tx.sh
