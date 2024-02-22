#!/bin/bash

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
DIR="$(dirname "$0")"

axelard tx snapshot register-proxy $(axelard keys show gov1 -a ${DEFAULT_KEYS_FLAGS}) \
--chain-id ${CHAIN_ID} --from owner ${DEFAULT_KEYS_FLAGS} \
--output json --gas 1000000

axelard tx nexus register-chain-maintainer avalanche ethereum fantom moonbeam polygon \
--chain-id ${CHAIN_ID} --from gov1 ${DEFAULT_KEYS_FLAGS} \
--output json --gas 1000000


