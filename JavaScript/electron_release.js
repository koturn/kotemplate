(function(global, undefined) {
  'use strict';

  var config = require('./package.json');
  require('electron-packager')({
    dir: './',
    out: './bin',
    name: config.name,
    platform: 'win32,darwin',
    arch: 'x64',
    version: config.version
    // icon: './app.icns',

    'app-bundle-id': 'kotun.github.io',
    'app-version': config.version,
    'helper-bundle-id': 'koturn.github.io',
    overwrite: true,
    asar: true,
    prune: true,
    ignore: "node_modules/(electron-packager|electron-prebuilt|\.bin)|release\.js",
    'version-string': {
      CompanyName: '<+AUTHOR+>',
      FileDescription: config.description,
      OriginalFilename: config.name,
      FileVersion: config.version,
      ProductVersion: config.version,
      ProductName: config.name,
      InternalName: config.name
    }
  }, function(err, appPath) {
    if (err) {
      throw new Error(err);
    }
    console.log('Done!!');
    <+CURSOR+>
  });
})((this || 0).self || global);
