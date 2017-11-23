module.exports = {
  entry: {
    'gaplaylength': ['./src/gaplaylength.js'],
    'jquery.gaplaylength': './src/jquery.gaplaylength.js'
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
  output: {
    path: './dist',
    filename: '[name].js',
    library: '[name]',
    libraryTarget: 'umd'
  }
}
