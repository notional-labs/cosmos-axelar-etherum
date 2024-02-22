#!/bin/bash

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
DIR="$(dirname "$0")"

axelard tx multisig submit-pubkey --id "harvey" --generate-only \
--chain-id ${CHAIN_ID} --from $(axelard keys show gov1 -a ${DEFAULT_KEYS_FLAGS}) --home ${HOME} \
--output json --gas 500000 &> ${HOME}/unsigned_msg.json

cat ${HOME}/unsigned_msg.json

sh ./scripts/bin/libs/broadcast-unsigned-multi-tx.sh

