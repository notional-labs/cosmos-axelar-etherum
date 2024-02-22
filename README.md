# cosmos-axelar-etherum

Script root: cosmos-axelar-etherum (this folder)

Build folder: \_build

- \_build/gocache: contains relevant go packages
- \_build/binary: contains all relevant binary
- \_build/axelar-core: code of axelar-core
- \_build/solidity: antifacts of solidity contracts

Testnet folder: testnet
- testnet/axelar-testnet
- testnet/evm-testnet
- testnet/cudos-testnet

## Port management

### Cudos
| Type | Port  |
| ---- | ----- |
| RPC  | 16657 |
| P2P  | 16656 | 

### Axelar
| Type | Port  |
| ---- | ----- |
| RPC  | 26657 |
| P2P  | 26656 | 

## Setup etherum environment

1. install node 18.x as required by axelar example

```bash
# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# load nvm into environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# confirm binary recognized by env
command -v nvm

# install node
nvm install 18

# confirm node version 18
node -v
```
