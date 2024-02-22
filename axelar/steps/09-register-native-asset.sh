#!/bin/sh

CHAIN_ID=axelar
HOME=.axelar
DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME}"
CHAIN=$1
DENOM=${2:-uumee}
DIR="$(dirname "$0")"

if [ -z "$CHAIN" ]
then
  echo "Chain name is required"
  exit 1
fi

echo "Registering asset ${CHAIN} ${DENOM}"
axelard tx axelarnet register-asset ${CHAIN} ${DENOM} --is-native-asset --generate-only \
--chain-id ${CHAIN_ID} --from $(axelard keys show governance -a ${DEFAULT_KEYS_FLAGS}) ${DEFAULT_KEYS_FLAGS} \
--output json --gas 500000 &> ${HOME}/unsigned_msg.json
cat ${HOME}/unsigned_msg.json
#echo "Registered asset ${CHAIN} ${DENOM}"

sh ./scripts/bin/libs/broadcast-unsigned-multi-tx.sh
