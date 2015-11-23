var buildConfig = require('hjs-webpack')

module.exports = buildConfig({
  // default port. used for dev server, also recommended when serving static.
  port: '7892',

  // entry point for the app
  in: 'app.js',
  out: 'dist',

  // more webpack conf
  clearBeforeBuild: true,
  isDev: process.env.NODE_ENV !== 'production',

  // // TODO: config loaders, require by file extension
  // module: {
  //   loaders: [
  //     { test: /\.coffee$/, loader: "coffee-loader" },
  //     { test: /\.cjsx$/, loader: "coffee-jsx-loader" }
  //   ]
  // }

})
