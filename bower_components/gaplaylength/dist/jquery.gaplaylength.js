(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define(factory);
	else if(typeof exports === 'object')
		exports["jquery.gaplaylength"] = factory();
	else
		root["jquery.gaplaylength"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

	var _gaplaylength = __webpack_require__(1);

	var _module = _interopRequireWildcard(_gaplaylength);

	jQuery.fn.gaPlayLength = function (options) {
	  return this.each(function () {
	    _module.init(this, options);
	  });
	};

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	/*!
	 * gaplaylength.js | v0.3
	 * Copyright (c) 2015 Leigh McCulloch
	 * Licensed under the ICS license.
	 *
	 * Inspired by and derived from jquery.scrolldepth.js
	 * which may be freely distributed under the MIT and GPL licenses.
	 * Copyright (c) 2014 Rob Flaherty (@robflaherty).
	 */

	'use strict';

	Object.defineProperty(exports, '__esModule', {
	  value: true
	});
	exports.init = init;

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

	var _addeventlistener = __webpack_require__(2);

	var _addeventlistener2 = _interopRequireDefault(_addeventlistener);

	var _throttle = __webpack_require__(3);

	var _throttle2 = _interopRequireDefault(_throttle);

	function init(element) {
	  var _ref = arguments[1] === undefined ? {} : arguments[1];

	  var _ref$audioTime = _ref.audioTime;
	  var audioTime = _ref$audioTime === undefined ? true : _ref$audioTime;
	  var _ref$userTiming = _ref.userTiming;
	  var userTiming = _ref$userTiming === undefined ? true : _ref$userTiming;

	  var universalGA;
	  var classicGA;
	  var googleTagManager;

	  var cache = [];
	  var startTime = +new Date();
	  var lastCurrentTime;

	  /*
	   * Determine which version of GA is being used
	   * "ga", "_gaq", and "dataLayer" are the possible globals
	   */

	  if (typeof ga === 'function') {
	    universalGA = true;
	  }

	  if (typeof _gaq !== 'undefined' && typeof _gaq.push === 'function') {
	    classicGA = true;
	  }

	  if (typeof dataLayer !== 'undefined' && typeof dataLayer.push === 'function') {
	    googleTagManager = true;
	  }

	  /*
	   * Functions
	   */

	  function sendEvent(action, label, currentTime, timing) {

	    if (googleTagManager) {

	      dataLayer.push({ 'event': 'PlayLength', 'eventCategory': 'Play Length', 'eventAction': action, 'eventLabel': label, 'eventValue': 1, 'eventNonInteraction': true });

	      if (audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
	        lastCurrentTime = currentTime;
	        dataLayer.push({ 'event': 'PlayLength', 'eventCategory': 'Play Length', 'eventAction': 'Audio Time', 'eventLabel': rounded(currentTime), 'eventValue': 1, 'eventNonInteraction': true });
	      }

	      if (userTiming && arguments.length > 3) {
	        dataLayer.push({ 'event': 'PlayTiming', 'eventCategory': 'Play Length', 'eventAction': action, 'eventLabel': label, 'eventTiming': timing });
	      }
	    } else {

	      if (universalGA) {

	        ga('send', 'event', 'Play Length', action, label, 1, { 'nonInteraction': 1 });

	        if (audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
	          lastCurrentTime = currentTime;
	          ga('send', 'event', 'Play Length', 'Audio Time', rounded(currentTime), 1, { 'nonInteraction': 1 });
	        }

	        if (userTiming && arguments.length > 3) {
	          ga('send', 'timing', 'Play Length', action, timing, label);
	        }
	      }

	      if (classicGA) {

	        _gaq.push(['_trackEvent', 'Play Length', action, label, 1, true]);

	        if (audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
	          lastCurrentTime = currentTime;
	          _gaq.push(['_trackEvent', 'Play Length', 'Audio Time', rounded(currentTime), 1, true]);
	        }

	        if (userTiming && arguments.length > 3) {
	          _gaq.push(['_trackTiming', 'Play Length', action, timing, label, 100]);
	        }
	      }
	    }
	  }

	  function calculateMarks(durationSeconds) {
	    return {
	      '10%': parseInt(durationSeconds * 0.10, 10),
	      '25%': parseInt(durationSeconds * 0.25, 10),
	      '50%': parseInt(durationSeconds * 0.50, 10),
	      '75%': parseInt(durationSeconds * 0.75, 10)
	    };
	  }

	  function rounded(currentTime) {
	    // Returns String, rounded currentTime to 10 second intervals
	    return (Math.floor(currentTime / 10) * 10).toString();
	  }

	  /*
	   * Audio Event Handlers
	   */

	  function onPlay() {
	    var key = 'Baseline';
	    if (cache.indexOf(key) === -1) {
	      sendEvent('Percentage', key);
	      cache.push(key);
	    }
	  }

	  function onTimeUpdate() {
	    var duration = element.duration;
	    var currentTime = element.currentTime;
	    if (isNaN(element.duration)) {
	      return;
	    }

	    var marks = calculateMarks(duration);
	    var timing = +new Date() - startTime;

	    for (var key in marks) {
	      var val = marks[key];
	      if (cache.indexOf(key) === -1 && currentTime >= val) {
	        sendEvent('Percentage', key, currentTime, timing);
	        cache.push(key);
	      }
	    }
	  }

	  function onEnded() {
	    var key = '100%';
	    if (cache.indexOf(key) === -1) {
	      var timing = +new Date() - startTime;
	      sendEvent('Percentage', key, element.duration, timing);
	      cache.push(key);
	    }
	  }

	  /*
	   * Audio Events
	   */

	  (0, _addeventlistener2['default'])(element, 'play', onPlay, false);
	  (0, _addeventlistener2['default'])(element, 'timeupdate', (0, _throttle2['default'])(onTimeUpdate, 500), false);
	  (0, _addeventlistener2['default'])(element, 'ended', onEnded, false);
	}

	;

/***/ },
/* 2 */
/***/ function(module, exports) {

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports["default"] = addEventListener;

	function addEventListener(element, eventName, callback, something) {
	  if (element.addEventListener) {
	    element.addEventListener(eventName, callback, something);
	  } else if (element.attachEvent) {
	    element.attachEvent(eventName, callback);
	  }
	}

	module.exports = exports["default"];

/***/ },
/* 3 */
/***/ function(module, exports) {

	/*!
	 * Throttle function borrowed from:
	 * Underscore.js 1.5.2
	 * http://underscorejs.org
	 * (c) 2009-2013 Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
	 * Underscore may be freely distributed under the MIT license.
	 */

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports["default"] = throttle;

	function throttle(func, wait) {
	  var context, args, result;
	  var timeout = null;
	  var previous = 0;
	  var later = function later() {
	    previous = new Date();
	    timeout = null;
	    result = func.apply(context, args);
	  };
	  return function () {
	    var now = new Date();
	    if (!previous) previous = now;
	    var remaining = wait - (now - previous);
	    context = this;
	    args = arguments;
	    if (remaining <= 0) {
	      clearTimeout(timeout);
	      timeout = null;
	      previous = now;
	      result = func.apply(context, args);
	    } else if (!timeout) {
	      timeout = setTimeout(later, remaining);
	    }
	    return result;
	  };
	}

	module.exports = exports["default"];

/***/ }
/******/ ])
});
;