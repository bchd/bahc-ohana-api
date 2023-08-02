const path    = require("path")
const webpack = require("webpack")

// Extracts CSS into .css file
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

module.exports = {
  mode,
  devtool: 'source-map',
  optimization: {
    moduleIds: 'deterministic',
  },
  entry: {
    application: "./app/javascript/application.js"
  },
  output: {
    filename: "[name]_pack.js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, "app/assets/builds"),
  },
  module: {
    rules: [
      // Add CSS/SASS/SCSS rule with loaders
      {
        test: /\.(?:sa|sc|c)ss$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
      {
        test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
        use: 'file-loader',
      },
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.jsx', '.scss', '.css'],
  },
  plugins: [
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin({
      filename: "[name]_pack.css"
    }),
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ]
}
