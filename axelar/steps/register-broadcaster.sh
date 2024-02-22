#!/bin/bash

$BINARY tx snapshot register-proxy $($BINARY keys show gov1 -a ${DEFAULT_KEYS_FLAGS}) \
--chain-id ${CHAIN_ID} --from owner ${DEFAULT_KEYS_FLAGS} \
--output json --gas 1000000

$BINARY tx nexus register-chain-maintainer avalanche ethereum fantom moonbeam polygon \
--chain-id ${CHAIN_ID} --from gov1 ${DEFAULT_KEYS_FLAGS} \
--output json --gas 1000000


