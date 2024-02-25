#!/bin/bash

echo ""
echo "##################"
echo "# Create relayer #"
echo "##################"
echo ""

# Configure predefined mnemonic pharses
ROOT=$(pwd)
BINARY=_build/binary/relayer
CHAIN_DIR=$(pwd)/testnet
CHAINID_1=cudos
CHAINID_2=axelar
RELAYER_DIR=/relayer
MNEMONIC_1="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"
MNEMONIC_2="record gift you once hip style during joke field prize dust unique length more pencil transfer quit train device arrive energy sort steak upset"
RELAY_PATH=cudos-axelar

# check if relayer not installed
if ! [ -x "$(command -v $BINARY)" ]; then
    echo "installing $BINARY ..."
    cd deps/relayer
    GOBIN="$ROOT/_build/binary" go install -mod=readonly ./...
    cd ../..
fi

echo "Initializing $BINARY..."
$BINARY config init --home $CHAIN_DIR/$RELAYER_DIR

echo "Adding configurations for both chains..."
$BINARY chains add-dir ./relayer/setup/chains --home $CHAIN_DIR/$RELAYER_DIR
$BINARY paths add $CHAINID_1 $CHAINID_2 cudos-axelar --file ./relayer/setup/paths/cudos-axelar.json --home $CHAIN_DIR/$RELAYER_DIR

echo "Restoring accounts..."
$BINARY keys restore $CHAINID_1 testkey "$MNEMONIC_1" --home $CHAIN_DIR/$RELAYER_DIR
$BINARY keys restore $CHAINID_2 testkey "$MNEMONIC_2" --home $CHAIN_DIR/$RELAYER_DIR
#
#echo "Creating clients and a connection..."
#$BINARY tx connection $RELAY_PATH --home $CHAIN_DIR/$RELAYER_DIR
#
#echo "Creating a channel..."
#$BINARY tx channel $RELAY_PATH --home $CHAIN_DIR/$RELAYER_DIR

rly tx link $RELAY_PATH -d -t 3s --home $CHAIN_DIR/$RELAYER_DIR
echo "Starting to listen relayer..."
touch $CHAIN_DIR/$RELAYER_DIR/relayer-log.txt
screen -L -Logfile $CHAIN_DIR/$RELAYER_DIR/relayer-log.txt -dmS relayer $BINARY start $RELAY_PATH --home $CHAIN_DIR/$RELAYER_DIR

echo ""
echo "############################"
echo "# SUCCESS: Relayer created #"
echo "############################"
echo ""
