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
    let global = typeof window !== 'undefined' ? window
      : typeof self !== 'undefined' ? self
      : null;
    if (global === null) {
      // SpiderMonkey or Rhino
      try {
        global = Function('return this')();
      } catch (Error) {
        throw new Error('This environment was not anticipated by <+FILE+>.');
      }
    }

    // Get the `window` object, save the previous <+FILE_PASCAL+> global
    // and initialize <+FILE_PASCAL+> as a global.
    const prevDefinition = global.<+FILE_PASCAL+>;
    global.<+FILE_PASCAL+> = moduleDef();

    // Add a noConflict function so <+FILE_PASCAL+> can be removed from
    // the global namespace.
    global.<+FILE_PASCAL+>.noConflict = function() {
      if (typeof prevDefinition === 'undefined') {
        delete global.<+FILE_PASCAL+>;
      } else {
        global.<+FILE_PASCAL+> = prevDefinition;
      }
      return this;
    };
  }
})(function() {
  'use strict';

  /**
   * Class definition.
   */
  return class <+FILE_PASCAL+> {
    // Define member variables.
    /**
     * First member variable.
     * @type {number}
     */
    #memberVar01;
    /**
     * Second member variable.
     * @type {number}
     */
    #memberVar02;

    /**
     * constructor
     * @param {number} arg Argument
     */
    constructor(arg) {
      // Initialize member variables.
      this.#memberVar01 = arg;
      this.#memberVar02 = 42;

      // Define properties.
      Object.defineProperty(this, 'prop', {
        get: function() {
          return this._memberVar01;
        },
        set: function(value) {
          this._memberVar01 = value;
        },
      });
    }

    /**
     * A method.
     */
    method() {
      <+CURSOR+>
    }

    /**
     * noConflict() for non global.
     */
    static noConflict() {
      throw new Error('<+FILE_PASCAL+>.noConflict only works when <+FILE_PASCAL+> is used as a global');
    }
  };
});
