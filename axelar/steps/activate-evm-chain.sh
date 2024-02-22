#!/bin/bash

CHAIN=${1:-Ethereum}
DIR="$(dirname "$0")"

sh ./axelar/bin/libs/activate-chain.sh ${CHAIN}
sh ./axelar/bin/libs/activate-chain.sh axelarnet
