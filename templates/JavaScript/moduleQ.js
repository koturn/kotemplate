;(function(moduleDef) {
  'use strict';

  // https://github.com/kriskowal/q

  // This file will function properly as a <script> tag,
  // or a module using CommonJS and NodeJS or RequireJS module formats.
  // In Common/Node/RequireJS, the module exports the <+FILE_PASCAL+> API
  // and when executed as a simple <script>, it creates a <+FILE_PASCAL+> global instead.

  if (typeof bootstrap === 'function') {
    // Montage Require
    bootstrap('promise', moduleDef);
  } else if (typeof exports === 'object' && typeof module === 'object') {
    // NodeJS or CommonJS
    module.exports = moduleDef();
  } else if (typeof define === 'function' && define.amd) {
    // RequireJS
    define(moduleDef);
  } else if (typeof ses !== 'undefined') {
    // SES (Secure EcmaScript)
    if (!ses.ok()) {
      return;
    } else {
      ses.make<+FILE_PASCAL+> = moduleDef;
    }
  } else if (typeof window !== 'undefined' || typeof self !== 'undefined') {
    // <script>
    // Prefer window over self for add-on scripts.
    // Use self for non-windowed contexts.
    var global = typeof window !== "undefined" ? window : self;

    // Get the `window` object, save the previous <+FILE_PASCAL+> global
    // and initialize <+FILE_PASCAL+> as a global.
    var previous<+FILE_PASCAL+> = global.<+FILE_PASCAL+>;
    global.<+FILE_PASCAL+> = definition();

    // Add a noConflict function so <+FILE_PASCAL+> can be removed from
    // the global namespace.
    global.<+FILE_PASCAL+>.noConflict = function() {
      global.<+FILE_PASCAL+> = previous<+FILE_PASCAL+>;
      return this;
    };
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

  <+FILE_PASCAL+>.noConflict = function() {
    throw new Error("<+FILE_PASCAL+>.noConflict only works when <+FILE_PASCAL+> is used as a global");
  };

  return <+FILE_PASCAL+>;
});
