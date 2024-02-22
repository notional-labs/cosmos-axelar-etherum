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
screen -L -dmS evm-testnet sh -c 'npm run start > $HOME/evm-log.txt 2>&1'

sleep 5

npm run send-token Ethereum cudos 1000 > $HOME/evm-log.txt 2>&1

cd ..

