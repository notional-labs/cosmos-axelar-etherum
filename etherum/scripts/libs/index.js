require('dotenv').config();

const path = require('path');
const rootPath = path.resolve(__dirname, '../..');
global.rootRequire = (name) => require(`${rootPath}/${name}`);

module.exports = {
    ...require('./start'),
    ...require('./utils'),
};
