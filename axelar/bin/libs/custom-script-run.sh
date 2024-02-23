#!/bin/bash

NODE_HOME=testnet/axelar-testnet
CHAIN_ID=axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home $NODE_HOME"
BINARY="_build/binary/axelard"

export NODE_HOME
export CHAIN_ID
export DEFAULT_KEYS_FLAGS
export BINARY

$1