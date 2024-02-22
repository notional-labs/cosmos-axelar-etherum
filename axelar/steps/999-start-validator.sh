#!/bin/bash

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
VALIDATOR_ADDR=$1
DIR="$(dirname "$0")"

docker exec axelar /bin/bash -c "axelard vald-start --validator-addr axelarvaloper19jqwxwh0sh9r95gp3wtuhamcntd00n03dqlht2 \
--chain-id ${CHAIN_ID} --home ${HOME} --keyring-backend test --gas 500000"


