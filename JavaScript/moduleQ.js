;(function(moduleDef) {
  'use strict';

  if (typeof bootstrap === 'function') {  // Montage Require
    bootstrap('promise', moduleDef);
  } else if (typeof exports === 'object' && typeof module === 'object') {  // NodeJS or CommonJS
    module.exports = moduleDef();
  } else if (typeof define === 'function' && define.amd) {  // RequireJS
    define(moduleDef);
  } else if (typeof ses !== 'undefined') {  // SES (Secure EcmaScript)
    if (!ses.ok()) {
      return;
    } else {
      ses.make<+FILE_PASCAL+> = moduleDef;
    }
  } else if (typeof window !== 'undefined' || typeof self !== 'undefined') {  // <script>
    (typeof window !== 'undefined' && window || self).<+FILE_PASCAL+> = moduleDef();
  } else {
    var global = Function('return this')();
    if (global.print) {  // SpiderMonkey or Rhino
      global.<+FILE_PASCAL+> = moduleDef();
    } else {
      throw new Error('This environment was not anticipated by <+FILE+>.');
    }
  }
})(function() {
  'use strict';

  function <+FILE_PASCAL+>() {};

  <+FILE_PASCAL+>.prototype.method = function() {
    <+CURSOR+>
  };

  return <+FILE_PASCAL+>;
});
