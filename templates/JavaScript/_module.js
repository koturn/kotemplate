;(function(global) {
  "use strict";

  // identify environment
  // var isBrowser = "document" in global;
  // var isWebWorkers = "WorkerLocation" in global;
  // var isNode = "process" in global;

  // Class ------------------------------------------------
  function YourModule() {
  }

  // Header -----------------------------------------------
  YourModule["prototype"]["method"] = YourModule_method; // YourModule#method(someArg:any):void

  // Implementation ---------------------------------------
  function YourModule_method(someArg) {
    // ...
  }

  // Exports ----------------------------------------------
  if ("process" in global) {
    module["exports"] = YourModule;
  }
  global["YourModule"] = YourModule;
})((this || 0).self || global);
