#!/bin/bash

CHAIN=${1:-wasm}
DIR="$(dirname "$0")"

sh ./scripts/bin/libs/activate-chain.sh ${CHAIN}
