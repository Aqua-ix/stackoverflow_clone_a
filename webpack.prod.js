/* eslint-disable */
const path = require('path')

const DotEnv = require('dotenv-webpack')
const { param, common } = require('./webpack.common.js')
/* eslint-enable */

const extConfig = {
  mode: 'production',
}

const extPlugins = [
  new DotEnv({
    path: path.resolve(__dirname, `${param.dotEnvPath}/production.env`),
    safe: false,
  }),
]
const commonConfig = common(true)

module.exports = {
  ...commonConfig,
  ...extConfig,
  plugins: [...commonConfig.plugins, ...extPlugins],
}
