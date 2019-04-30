(function(main) {
  'use strict';

  if (typeof process !== 'undefined') {
    process.stdin.resume();
    process.stdin.setEncoding('utf8');

    var lines = [];
    require('readline').createInterface({
      input: process.stdin,
      output: process.stdout
    }).on('line', function(line) {
      lines.push(line);
    });
    process.stdin.on('end', function() {
      var lineCnt = 0;
      var nLine = lines.length;
      main(console.log, function() {
        return lineCnt < nLine ? lines[lineCnt++] : null;
      });
    });
  } else {
    main(print, readline);
  }
})(function(print, readline) {
  'use strict';

  var line;
  while ((line = readline()) !== null) {
    print(line.split(' ').map(Number));
    <+CURSOR+>
  }
});
