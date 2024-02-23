#!/usr/bin/env bash

ROOT=$(pwd)
cd deps/cudos-node
echo "Building cudos-node... $ROOT"
GOMODCACHE=$ROOT/_build/gocache make build
mv build/cudos-noded $ROOT/_build/binary
