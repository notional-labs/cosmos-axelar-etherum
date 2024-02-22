#!/bin/bash

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
DIR="$(dirname "$0")"
TX_HASH=$1

axelard tx evm confirm-erc20-token ethereum ethereum uusdc "${TX_HASH}"  --generate-only \
--chain-id ${CHAIN_ID} --from $(axelard keys show governance -a ${DEFAULT_KEYS_FLAGS}) --home ${HOME} \
--output json --gas 500000 &> ${HOME}/unsigned_msg.json

cat ${HOME}/unsigned_msg.json

sh ./scripts/bin/libs/broadcast-unsigned-multi-tx.sh

