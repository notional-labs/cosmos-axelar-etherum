#!/bin/bash

CHAIN=${1:-Ethereum}
DIR="$(dirname "$0")"

sh ./scripts/bin/libs/activate-chain.sh ${CHAIN}
sh ./scripts/bin/libs/activate-chain.sh axelarnet
