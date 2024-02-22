#!/bin/bash

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
CHAIN=$1
TXS=$2
DIR="$(dirname "$0")"

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

axelard tx evm confirm-gateway-txs ${CHAIN} ${TXS} --generate-only \
--chain-id ${CHAIN_ID} --from $(axelard keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${HOME} \
--output json --gas 500000 &> ${HOME}/unsigned_msg.json

cat ${HOME}/unsigned_msg.json

sh ./scripts/bin/libs/broadcast-unsigned-multi-tx.sh

