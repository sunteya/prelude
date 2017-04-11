module.exports = {
  test: /\.jsx?(\.erb)?$/,
  exclude: /node_modules/,
  loader: 'babel-loader',
  options: {
    presets: [
      ['env', { modules: false }]
    ]
  }
}
