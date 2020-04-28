/* eslint-disable */
const webpack = require('webpack')
const path = require('path')

const DotEnv = require('dotenv-webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const { param, common } = require('./webpack.common.js')
/* eslint-enable */

const extConfig = {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    allowedHosts: [
      '.localhost',
    ],
    port: 8082,
    inline: true,
    writeToDisk: true,  // force reload
  },
}

const extPlugins = [
  new DotEnv({
    path: path.resolve(__dirname, `${param.dotEnvPath}/development.env`),
    safe: false,
  }),
]

const commonConfig = common(false)

module.exports = {
  ...commonConfig,
  ...extConfig,
  plugins: [...commonConfig.plugins, ...extPlugins],
}
