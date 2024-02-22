const fs = require('fs');
const { ethers } = require('ethers');
const { createAndExport, EvmRelayer, RelayerType } = require('@axelar-network/axelar-local-dev');
const { configPath } = require('../../config');
const path = require('path');

const evmRelayer = new EvmRelayer();

const relayers = { evm: evmRelayer };
let tokenTxHash = "";
let tokenAddress = "";
/**
 * Start the local chains with Axelar contracts deployed.
 * aUSDC is deployed and funded to the given addresses.
 * @param {*} fundAddresses - addresses to fund with aUSDC
 * @param {*} chains - chains to start. All chains are started if not specified (Avalanche, Moonbeam, Polygon, Fantom, Ethereum).
 */
async function start(fundAddresses = [], chains = [], options = {}) {
    // For testing purpose
    const dropConnections = [];

    await createAndExport({
        chainOutputPath: configPath.localEvmChains,
        accountsToFund: fundAddresses,
        callback: (chain, _info) => deployAndFundUsdc(chain, fundAddresses),
        port: 7545,
        chains: chains.length !== 0 ? chains : null,
        relayers,
        relayInterval: options.relayInterval,
    });
    updateConfigFile(tokenTxHash, tokenAddress);

    return async () => {
        for (const dropConnection of dropConnections) {
            await dropConnection();
        }
    };
}

/**
 * Deploy aUSDC and fund the given addresses with 1e12 aUSDC.
 * @param {*} chain - chain to deploy aUSDC on
 * @param {*} toFund - addresses to fund with aUSDC
 */
async function deployAndFundUsdc(chain, toFund) {
    const pendingPromise = new Promise((resolve) => {
        // Listening on pending event
        chain.provider.on("pending", (tx) => {
            tokenTxHash = tx.hash; // Assign tokenTxHash
            chain.provider.off("pending");
            resolve(); // Resolve promise here
        });
    });
    const tokenDeploy = await chain.deployToken('Axelar Wrapped aUSDC', 'aUSDC', 6, ethers.utils.parseEther('1000'));
    tokenAddress = tokenDeploy.address;

    await pendingPromise;

    for (const address of toFund) {
        await chain.giveToken(address, 'aUSDC', ethers.utils.parseEther('1'));
    }
}

function updateConfigFile(txHashes, address) {
    const configFilePath = configPath.localEvmChains

    let config = {};

    if (fs.existsSync(configFilePath)) {
        const configFileContent = fs.readFileSync(configFilePath);
        config = JSON.parse(configFileContent);
    }

    config[0].tokenDeployTxHash = txHashes;
    config[0].tokenDeployAddress = address;

    fs.writeFileSync(configFilePath, JSON.stringify(config, null, 2));
}

/**
 * Initialize aptos if it is running.
 * If aptos is not running, skip initialization and print a message.
 */
async function initAptos(createAptosNetwork) {
    try {
        await createAptosNetwork({
            nodeUrl: 'http://0.0.0.0:8080',
            faucetUrl: 'http://0.0.0.0:8081',
        });
    } catch (e) {
        console.log('Skip Aptos initialization, rerun this after starting an aptos node for proper support.');
    }
}

module.exports = {
    start,
    evmRelayer,
    relayers,
};
