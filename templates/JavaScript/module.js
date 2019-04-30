;(function(global, undefined) {
  "use strict";

  // identify environment
  // var isBrowser = "document" in global;
  // var isWebWorkers = "WorkerLocation" in global;
  // var isNode = "process" in global;

  // Class ------------------------------------------------
  function <+FILE_PASCAL+>() {
    <+CURSOR+>
  }

  // Header -----------------------------------------------
  <+FILE_PASCAL+>.prototype.method = method; // YourModule#method(someArg:any):void

  // Implementation ---------------------------------------
  function method(someArg) {
  }

  // Exports ----------------------------------------------
  if ("process" in global) {
    module.exports = <+FILE_PASCAL+>;
  }
  global.<+FILE_PASCAL+> = <+FILE_PASCAL+>;
})((this || 0).self || global);
