const path = require("path");

module.exports = {
  mode: "development",

  entry: "./src/client/index.js",

  output: {
    path: path.resolve(__dirname, "static"),
    filename: "bundle.js",
  },

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "@sucrase/webpack-loader",
          options: {
            transforms: ["jsx"],
          },
        },
      },
    ],
  },
};