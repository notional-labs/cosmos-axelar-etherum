#!/usr/bin/env bash

ROOT=$(pwd)
HOME=$ROOT/testnet/evm-testnet
cd etherum

# check if there is node_modules folder
if [ ! -d "node_modules" ]; then
  npm install
fi

rm -rf $HOME
mkdir -p $HOME

# run new evm node
touch $HOME/evm-log.txt
screen -L -Logfile $HOME/evm-log.txt -dmS evm-testnet npm run start

cd ..