const path = require('path');

const configPath = {
    localEvmChains: path.resolve(__dirname, '../../testnet/evm-testnet', 'chain-config', 'local-evm.json'),
};

module.exports = {
    configPath,
};
