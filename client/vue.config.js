const fs = require('fs');

module.exports = {
  outputDir: '../mobile/www',
  publicPath: './',
  devServer: {
    progress: false,
    https: true,
    key: fs.readFileSync('./certs/localhost.key'),
    cert: fs.readFileSync('./certs/localhost.crt'),
  }
}
