
ROOT=$(pwd)
cd cudos-node
echo "Building cudos-node... $ROOT"
GOMODCACHE=$ROOT/_build/gocache make build
cp build/cudos-noded ../_build/
