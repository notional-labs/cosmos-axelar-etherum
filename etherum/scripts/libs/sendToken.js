'use strict';

const { getDefaultProvider, Contract } = require('ethers');
const {configPath} = require("../../config");
const fs = require("fs");
const Gateway = rootRequire(
    '../_build/solidity/artifacts/@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol/IAxelarGateway.json',
);
const IERC20 = rootRequire('../_build/solidity/artifacts/@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol/IERC20.json');

async function execute(chains, wallet, options = {}) {
    const args = options.args || [];
    const source = chains.find((chain) => chain.name == (args[0] || 'Avalanche'));
    const destinationChain = args[1] || 'cudos'
    const destinationAddress = args[2] || 10e6;
    const amount = args[3] || 10e6;
    const symbol = 'aUSDC';

    for (const chain of [source]) {
        const provider = getDefaultProvider(chain.rpc);
        chain.provider = provider;
        chain.wallet = wallet.connect(provider);
        chain.contract = new Contract(chain.gateway, Gateway.abi, chain.wallet);
        const tokenAddress = await chain.contract.tokenAddresses(symbol);
        chain.token = new Contract(tokenAddress, IERC20.abi, chain.wallet);
    }

    async function print() {
        console.log(`Balance of ${wallet.address} at ${source.name} is ${await source.token.balanceOf(wallet.address)}`);
    }

    console.log('--- Initially ---');
    await print();

    await (await source.token.approve(source.gateway, amount)).wait();

    let tokenTxHash = "";
    const pendingPromise = new Promise((resolve) => {
        // Listening on pending event
        source.provider.on("pending", (tx) => {
            tokenTxHash = tx.hash; // Assign tokenTxHash
            source.provider.off("pending");
            resolve(); // Resolve promise here
        });
    });

    await (await source.contract.sendToken(destinationChain, destinationAddress, symbol, amount)).wait();

    await pendingPromise;

    updateConfigFile(tokenTxHash); // Update config file with tokenTxHash
    console.log('--- After ---');
    await print();
}

function updateConfigFile(txHash) {
    const configDirectoryPath = configPath.localSendTokenTx;
    const configFileName = "tx.json";
    const configFilePath = `${configDirectoryPath}/${configFileName}`;

    let config = {};
    config.tx = txHash;

    try {
        fs.mkdirSync(configDirectoryPath, { recursive: true });

        fs.writeFileSync(configFilePath, JSON.stringify(config, null, 2));
    } catch (error) {
        console.error("Error writing config file:", error);
    }
}

module.exports = {
    execute,
};
