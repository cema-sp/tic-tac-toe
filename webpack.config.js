const webpack = require('webpack');
const path    = require('path');

const ExtractTextPlugin   = require('extract-text-webpack-plugin');
const HtmlWebpackPlugin   = require('html-webpack-plugin');
const CleanWebpackPlugin  = require('clean-webpack-plugin');
const autoprefixer        = require('autoprefixer');
const precss 							= require('precss');
const sugarss 						= require('sugarss');

const nodeEnv = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';

/**
 * Application-wide config
 */
const config = {
  // fayeUrl:    process.env.FAYE_EXT_URL,
};

const buildDir = 'build';

/**
 * ENV-indifferent plugins
 */
const plugins = [
  new CleanWebpackPlugin([buildDir], {
    verbose:  true,
    dry:      false,
    exclude:  ['.gitkeep'],
  }),
  new HtmlWebpackPlugin({
    inject:         true,
    template:       'html/index.ejs',
  }),
  new webpack.DefinePlugin({ 'process.env.NODE_ENV': JSON.stringify(nodeEnv) }),
  new webpack.LoaderOptionsPlugin({
    minimize: true,
    options: {
      postcss: [
				precss({
					import: { disable: true },
				}),
        autoprefixer({ browsers: ['last 2 versions', '> 5%'] }),
      ],
    },
  }),
];

/**
 * ENV-indifferent entry
 */
const entry = {
  'js/bundle': [
    'whatwg-fetch',
    './css/index.sss',
    './js/index.js',
  ],
};

let elmLoader;
let cssLoader;
let devServer;

/**
 * ENV-dependent configs
 */
if (nodeEnv === 'production') {
  plugins.push(new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: false,
      screw_ie8: true,
    },
  }));

  plugins.push(new ExtractTextPlugin({
    filename: 'css/style_[contenthash].css',
    allChunks: true,
  }));

  elmLoader = 'elm-webpack';
  cssLoader = ExtractTextPlugin.extract({ fallbackLoader: 'style', loader: 'css!postcss?parser=sugarss' });
} else { // nodeEnv === 'development'
  devServer = {
		inline: true,
		stats: 'errors-only',
    progress: true,
	};

	elmLoader = 'elm-hot!elm-webpack?verbose=true&warn=true';
  cssLoader = 'style!css!postcss?parser=sugarss';
  entry['js/bundle'].unshift('webpack-dev-server/client?http://localhost:8888');
}

module.exports = {
  cache: true,
  context: path.resolve('assets'),
  entry,
	devServer,
  output: {
    path:       path.resolve(buildDir),
    // publicPath: '/', // Adds prefix to assets paths
    filename:   '[name]_[hash].js',
  },
  resolve: {
    extensions: ['.js', '.elm'],
    modules: [
      path.resolve('assets'),
      path.resolve('node_modules'),
    ],
  },
  externals: {
    config: JSON.stringify(config),
  },
  module: {
    noParse: /\.elm$/,
    loaders: [
      {
        test:     /\.elm$/,
        exclude:  [/node_modules/, /elm-stuff/],
        loader:   elmLoader,
      },
      {
        test:     /\.(c|s)ss$/,
        exclude:  [/node_modules/, /elm-stuff/],
        loader:   cssLoader,
      },
    ],
  },
  plugins,
};

