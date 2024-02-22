#!/bin/bash

## Sign unsigned transaction.
$BINARY tx sign ${NODE_HOME}/unsigned_msg.json --from gov1 \
--multisig $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) \
--chain-id $CHAIN_ID ${DEFAULT_KEYS_FLAGS} &> ${NODE_HOME}/signed_tx.json
cat ${NODE_HOME}/signed_tx.json

## Multisign signed transaction.
$BINARY tx multisign ${NODE_HOME}/unsigned_msg.json governance ${NODE_HOME}/signed_tx.json \
--from owner --sign-mode amino-json --chain-id $CHAIN_ID ${DEFAULT_KEYS_FLAGS} &> ${NODE_HOME}/tx-ms.json
cat ${NODE_HOME}/tx-ms.json

## Broadcast multisigned transaction.
$BINARY tx broadcast ${NODE_HOME}/tx-ms.json ${DEFAULT_KEYS_FLAGS} --sign-mode amino-json
