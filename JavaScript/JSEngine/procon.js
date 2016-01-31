(function() {
  'use strict';

  var line;
  while ((line = readline()) !== null) {
    var tokens = line.split(' ').map(Number);
    var a = tokens[0];
    var b = tokens[1];
    print(a + ' ' + b);
  }
})();
