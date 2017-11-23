var webpack = require('webpack');

module.exports = {
  entry: {
    'acceptedlanguagesui': './src/acceptedlanguagesui.js'
  },
  resolve:{
    modulesDirectories: [
      'src'
    ]
  },
  module: {
    loaders: [{
      test: /\.js$/,
      loader: 'babel-loader',
    }],
  },
  externals: [
    'acceptedlangauges'
  ],
  output: {
    path: './dist',
    filename: '[name].js',
    library: '[name]',
    libraryTarget: 'umd'
  }
}
