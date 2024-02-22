#!/bin/sh

CHAIN=$1
DENOM=${2:-uumee}

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

echo "Registering asset ${CHAIN} ${DENOM}"
$BINARY tx axelarnet register-asset ${CHAIN} ${DENOM} --is-native-asset --generate-only \
--chain-id ${CHAIN_ID} --from $($BINARY keys show governance -a ${DEFAULT_KEYS_FLAGS}) ${DEFAULT_KEYS_FLAGS} \
--output json --gas 500000 &> ${NODE_HOME}/unsigned_msg.json
cat ${NODE_HOME}/unsigned_msg.json
#echo "Registered asset ${CHAIN} ${DENOM}"

sh ./axelar/bin/libs/broadcast-unsigned-multi-tx.sh
