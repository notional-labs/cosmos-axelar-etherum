#!/bin/bash

CHAIN=$1

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi
echo "Activating chain: $CHAIN"
$BINARY tx nexus activate-chain ${CHAIN} --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${NODE_HOME} \
--output json --gas 500000 -y
