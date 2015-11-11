(function(global, undefined) {
  'use strict';

  var app = require('app');
  var BrowserWindow = require('browser-window');
  require('crash-reporter').start();

  app.on('window-all-closed', app.quit);
  app.on('ready', function() {
    var mainWindow = new BrowserWindow({width: 800, height: 600});
    mainWindow.loadUrl('file://' + __dirname + '/index.html');
    mainWindow.on('closed', function() {
      mainWindow = null;
    });
    <+CURSOR+>
  });
})((this || 0).self || global);
