/* eslint-disable */
const webpack = require('webpack')
const path = require('path')

const CopyPlugin = require('copy-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const LicenseWebpackPlugin = require('license-webpack-plugin').LicenseWebpackPlugin
/* eslint-enable */

const param = {
  entryPath: './web/static/main.tsx',
  distPath: './priv/static',
  dotEnvPath: './web/static/envs',
  templatePath: './web/static/assets/html/template.html',
}

const plugins = [
  new MiniCssExtractPlugin({
    filename: './[name].css', // specified path from the output.path
    chunkFilename: '[id].css',
  }),
  new CopyPlugin([
    {
      from: 'web/static/assets/raw',
    },
  ]),
  new LicenseWebpackPlugin({
    perChunkOutput: false,
    stats: {
      warnings: false, // suppress warnings for the oss which has no license information.
      errors: true,
    },
    outputFilename: 'webAppLicense.txt',
  }),
  new webpack.DefinePlugin({
    __IS_STORYBOOK_MODE__: JSON.stringify(false),
  }),
]

const common = isProd => ({
  entry: param.entryPath,
  output: {
    filename: '[name].bundle.js',
    chunkFilename: '[name].bundle.js',
    path: path.resolve(__dirname, param.distPath),
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'web/static'),
    },
    extensions: ['.tsx', '.ts', '.jsx', '.js', '.scss', '.sass', '.css', '.yaml', '.yml'],
  },
  module: {
    rules: [
      { test: /\.(ts|tsx)$/, use: 'ts-loader', exclude: /node_modules/ },
      { test: /\.(yaml|yml)$/, use: ['json-loader', 'yaml-loader'] },
      {
        test: /\.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: true, // for reading all image on training
            },
          },
        ],
      },
      { test: /\.(js)$/, use: 'source-map-loader', enforce: 'pre' },
      {
        test: /\.(css|scss|sass)$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              publicPath: '../',
              hmr: !isProd,
            },
          },
          {
            loader: 'css-loader',
            options: {
              modules: {
                localIdentName: '[local]__[hash:base64:5]',
              },
              importLoaders: 1,
              sourceMap: !isProd,
            },
          },
          'sass-loader',
        ],
      },
    ],
  },
  // optimization,
  plugins,
})

module.exports = { param, common }
