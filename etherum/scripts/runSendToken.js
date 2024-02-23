'use strict';
require('dotenv').config();
const {
    checkEnv,
    getWallet,
    getEVMChains,
} = require('./libs');

const args = process.argv.slice(2,6);

// Get the example object.
const {execute} = require("./libs/sendToken");

// Get the wallet.
const wallet = getWallet();

// Get the chains for the environment.
let selectedChains = ['Ethereum'];

const chains = getEVMChains(selectedChains);
execute(chains, wallet, {
    args,
});

/**
 * Get the source chain. If no source chain is provided, use Avalanche.
 * @param {*} chains - The chain objects to execute on.
 * @param {*} args - The arguments to pass to the example script.
 * @param {*} exampleSourceChain - The default source chain per example. If not provided, use Avalanche.
 * @returns The source chain.
 */
function getSourceChain(chains, args, exampleSourceChain) {
    return chains.find((chain) => chain.name === (args[0] || exampleSourceChain || 'Avalanche'));
}
