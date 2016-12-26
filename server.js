var express = require('express');
var path = require('path');

initApp();

function initApp () {
  var app = express();

  app.set('port', (process.env.PORT || 3000));

  app.use('/dist', express.static(path.join(__dirname, 'dist')));
  app.use('/assets', express.static(path.join(__dirname, 'assets')));

  app.get('/', function (req, res) {
    res.sendFile(path.join(__dirname, '/index.html'));
  });

  app.get('/favicon.ico', function (req, res) {
    res.sendFile(path.join(__dirname, '/assets/favicon.ico'));
  });

  app.listen(app.get('port'), function () {
    console.log(`Running app listening on port ${app.get('port')}.`);
  });
}
