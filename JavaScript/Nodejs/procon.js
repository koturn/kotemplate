(function() {
  'use strict';

  var lines = [];
  require('readline').createInterface({
    input: process.stdin,
    output: process.stdout
  }).on('line', function(line) {
    lines.push(line);
  });
  process.stdin.on('end', function() {
    lines.forEach(function(line) {
      var tokens = line.split(' ');
      console.log(tokens);
      <+CURSOR+>
    });
  });
})();
