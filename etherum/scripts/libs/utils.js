const { Wallet, ethers } = require('ethers');
const path = require('path');
const fs = require('fs-extra');
const { configPath } = require('../../config');

/**
 * Get the wallet from the environment variables. If the EVM_PRIVATE_KEY environment variable is set, use that. Otherwise, use the EVM_MNEMONIC environment variable.
 * @returns {Wallet} - The wallet.
 */
function getWallet() {
    checkWallet();
    const privateKey = process.env.EVM_PRIVATE_KEY;
    return privateKey ? new Wallet(privateKey) : Wallet.fromMnemonic(process.env.EVM_MNEMONIC);
}

/**
 * Check if the wallet is set. If not, throw an error.
 */
function checkWallet() {
    if (process.env.EVM_PRIVATE_KEY == null && process.env.EVM_MNEMONIC == null) {
        throw new Error('Need to set EVM_PRIVATE_KEY or EVM_MNEMONIC environment variable.');
    }
}

/**
 * Get the chain objects from the chain-config file.
 * @param {*} env - The environment to get the chain objects for. Available options are 'local' and 'testnet'.
 * @param {*} chains - The list of chains to get the chain objects for. If this is empty, the default chains will be used.
 * @returns {Chain[]} - The chain objects.
 */
function getEVMChains(chains = []) {

    const selectedChains = chains.length > 0 ? chains : getDefaultChains(env);

    return fs.readJsonSync(configPath.localEvmChains).filter((chain) => selectedChains.includes(chain.name));
}

function readChainConfig(filePath) {
    if (!fs.existsSync(filePath)) {
        return undefined;
    }

    return fs.readJsonSync(filePath);
}

module.exports = {
    getWallet,
    checkWallet,
    getEVMChains,
};
