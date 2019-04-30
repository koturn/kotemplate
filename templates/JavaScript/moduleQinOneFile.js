;(function(moduleDef) {
  'use strict';

  var module;
  if (typeof bootstrap === 'function') {  // Montage Require
    bootstrap('promise', moduleDef);
  } else if (typeof exports === 'object' && typeof module === 'object') {  // NodeJS or CommonJS
    module.exports = module = moduleDef();
  } else if (typeof define === 'function' && define.amd) {  // RequireJS
    define(moduleDef);
  } else if (typeof ses !== 'undefined') {  // SES (Secure EcmaScript)
    if (!ses.ok()) {
      return;
    } else {
      ses.make<+FILE_PASCAL+> = moduleDef;
    }
  }
  Function('return this')().<+FILE_PASCAL+> = typeof module === 'undefined' && moduleDef() || module;
})(function() {
  'use strict';

  function <+FILE_PASCAL+>() {};

  <+FILE_PASCAL+>.prototype.method = function() {
    <+CURSOR+>
  };

  return <+FILE_PASCAL+>;
});
