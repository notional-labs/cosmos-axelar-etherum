#!/usr/bin/env bash

ROOT=$(pwd)
DENOM=uaxl
CHAIN_ID=axelar
MONIKER=axelar
HOME_DIR=testnet/axelar-testnet
BINARY=${BINARY:-"_build/binary/axelard"}

# underscore so that go tool will not take gocache into account
mkdir -p _build/gocache
export GOMODCACHE=$ROOT/_build/gocache

# install $BINARY binary
if ! command -v _build/binary/$BINARY &> /dev/null
then
    echo "Building axelar-core..."
    cd deps/axelar-core
    GOBIN="$ROOT/_build/binary" go install -mod=readonly ./...
    cd ../..
fi

# Removing the existing directory to start with a clean slate
rm -rf ${HOME_DIR}/*
screen -S axelar-testnet -X kill
screen -S axelar-vald -X kill

DEFAULT_KEYS_FLAGS="--keyring-backend test --home ${HOME_DIR}"
ASSETS="100000000000000000000${DENOM}"

# Initializing a new blockchain with identifier ${CHAIN_ID} in the specified home directory
$BINARY init "$MONIKER" --chain-id ${CHAIN_ID} --home ${HOME_DIR} > /dev/null 2>&1 && echo "Initialized new blockchain with chain ID ${CHAIN_ID}"

# edit the app.toml file to enable the API and swagger
gsed -i '/\[api\]/,/\[/ s/enable = false/enable = true/' "$HOME_DIR"/config/app.toml
gsed -i '/\[api\]/,/\[/ s/swagger = false/swagger = true/' "$HOME_DIR"/config/app.toml

# staking/governance token is hardcoded in config, change this
gsed -i "s/\"stake\"/\"$DENOM\"/" "$HOME_DIR"/config/genesis.json && echo "Updated staking token to $DENOM"

# Adding a new key named 'owner' with a test keyring-backend in the specified home directory
# and storing the mnemonic in the mnemonic.txt file
mnemonic=$($BINARY keys add owner ${DEFAULT_KEYS_FLAGS} 2>&1 | tail -n 1)
echo ${mnemonic} | tr -d "\n" > ${HOME_DIR}/mnemonic.txt
echo "Added new key 'owner'"

gov1_mnemonic=$($BINARY keys add gov1 ${DEFAULT_KEYS_FLAGS} 2>&1 | tail -n 1)
echo ${gov1_mnemonic} | tr -d "\n" > ${HOME_DIR}/mnemonic-gov1.txt
echo "Added new key 'gov1'"

gov2_mnemonic=$($BINARY keys add gov2 ${DEFAULT_KEYS_FLAGS} 2>&1 | tail -n 1)
echo ${gov2_mnemonic} | tr -d "\n" > ${HOME_DIR}/mnemonic-gov2.txt
echo "Added new key 'gov2'"

$($BINARY keys add governance --multisig "gov1,gov2" --multisig-threshold 1 --nosort ${DEFAULT_KEYS_FLAGS} 2>&1 | tail -n 1)
echo "Added new key 'governance'"

# Adding a new genesis account named 'owner' with an initial balance of 100000000000000000000 in the blockchain
$BINARY add-genesis-account owner ${ASSETS} \
--home ${HOME_DIR} \
--keyring-backend test > /dev/null 2>&1 && echo "Added 'owner' to genesis account"

$BINARY add-genesis-account gov1 ${ASSETS} \
--home ${HOME_DIR} \
--keyring-backend test > /dev/null 2>&1 && echo "Added 'gov1' to genesis account"

$BINARY add-genesis-account gov2 ${ASSETS} \
--home ${HOME_DIR} \
--keyring-backend test > /dev/null 2>&1 && echo "Added 'gov2' to genesis account"

$BINARY add-genesis-account governance ${ASSETS} \
--home ${HOME_DIR} \
--keyring-backend test > /dev/null 2>&1 && echo "Added 'governance' to genesis account"

$BINARY set-genesis-mint --inflation-min 0 --inflation-max 0 --inflation-max-rate-change 0 --home ${HOME_DIR}
$BINARY set-genesis-gov --minimum-deposit "100000000${DENOM}" --max-deposit-period 90s --voting-period 90s --home ${HOME_DIR}
$BINARY set-genesis-reward --external-chain-voting-inflation-rate 0 --home ${HOME_DIR}
$BINARY set-genesis-slashing --signed-blocks-window 35000 --min-signed-per-window 0.50 --home ${HOME_DIR} \
--downtime-jail-duration 600s --slash-fraction-double-sign 0.02 --slash-fraction-downtime 0.0001 --home ${HOME_DIR}
$BINARY set-genesis-snapshot --min-proxy-balance 5000000 --home ${HOME_DIR}
$BINARY set-genesis-staking  --unbonding-period 168h --max-validators 50 --bond-denom "$DENOM" --home ${HOME_DIR}
$BINARY set-genesis-chain-params evm Ethereum --evm-network-name ethereum --evm-chain-id 5 --network ethereum --confirmation-height 1 --revote-locking-period 5 --home ${HOME_DIR}

GOV_1_KEY="$($BINARY keys show gov1 ${DEFAULT_KEYS_FLAGS} -p)"
GOV_2_KEY="$($BINARY keys show gov2 ${DEFAULT_KEYS_FLAGS} -p)"
$BINARY set-governance-key 1 "$GOV_1_KEY" "$GOV_2_KEY" --home ${HOME_DIR}
$BINARY validate-genesis --home ${HOME_DIR}

# Generating a new genesis transaction for 'owner' delegating 70000000${DENOM} in the blockchain with the specified chain-id
$BINARY gentx owner 70000000${DENOM} \
--home ${HOME_DIR} \
--keyring-backend test \
--moniker ${MONIKER} \
--chain-id ${CHAIN_ID} > /dev/null 2>&1 && echo "Generated genesis transaction for 'owner'"

# Collecting all genesis transactions to form the genesis block
$BINARY collect-gentxs \
--home ${HOME_DIR} > /dev/null 2>&1 && echo "Collected genesis transactions"

# Read the content of the local file and append it to the file inside the Docker container
cat ./deps/axelar-core/scripts/bin/libs/evm-rpc.toml >> "$HOME_DIR"/config/config.toml

# Starting the blockchain node with the specified home directory
touch $HOME_DIR/axelar-log.txt
screen -dmS axelar-testnet $BINARY start --home ${HOME_DIR} --minimum-gas-prices 0${DENOM} --moniker ${MONIKER}

OWNER_VAL_ADDRESS=$($BINARY keys show owner -a --bech val ${DEFAULT_KEYS_FLAGS})

# run new axelar node
touch $HOME/axelar-vald.txt
screen -dmS axelar-vald $BINARY vald-start --home $HOME --validator-addr $OWNER_VAL_ADDRESS --from gov1  --keyring-backend test
