(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define(factory);
	else if(typeof exports === 'object')
		exports["acceptedlanguagesui"] = factory();
	else
		root["acceptedlanguagesui"] = factory();
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

	Object.defineProperty(exports, '__esModule', {
	  value: true
	});
	exports.init = init;

	function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj['default'] = obj; return newObj; } }

	var _acceptedlanguagesuiRoot = __webpack_require__(1);

	var rootManager = _interopRequireWildcard(_acceptedlanguagesuiRoot);

	var _acceptedlanguagesuiLocalStorage = __webpack_require__(2);

	var localStorageManager = _interopRequireWildcard(_acceptedlanguagesuiLocalStorage);

	var page = acceptedlanguages.lib.page;
	var relevant = acceptedlanguages.lib.relevant;

	function createButton(text, cssClass) {
	  var button = document.createElement('button');
	  button.setAttribute('type', 'button');
	  button.className = cssClass;
	  button.innerHTML = text;
	  return button;
	}

	function init() {
	  var _ref = arguments[0] === undefined ? {} : arguments[0];

	  var _ref$insertElementIntoSelector = _ref.insertElementIntoSelector;
	  var insertElementIntoSelector = _ref$insertElementIntoSelector === undefined ? 'body' : _ref$insertElementIntoSelector;
	  var _ref$elementTag = _ref.elementTag;
	  var elementTag = _ref$elementTag === undefined ? 'div' : _ref$elementTag;
	  var _ref$elementId = _ref.elementId;
	  var elementId = _ref$elementId === undefined ? 'acceptedlanguagesui' : _ref$elementId;
	  var _ref$elementClass = _ref.elementClass;
	  var elementClass = _ref$elementClass === undefined ? 'acceptedlanguagesui' : _ref$elementClass;
	  var _ref$elementClassShow = _ref.elementClassShow;
	  var elementClassShow = _ref$elementClassShow === undefined ? 'show' : _ref$elementClassShow;
	  var _ref$elementClassHide = _ref.elementClassHide;
	  var elementClassHide = _ref$elementClassHide === undefined ? 'hide' : _ref$elementClassHide;
	  var _ref$buttonYesClass = _ref.buttonYesClass;
	  var buttonYesClass = _ref$buttonYesClass === undefined ? 'yes' : _ref$buttonYesClass;
	  var _ref$buttonNoClass = _ref.buttonNoClass;
	  var buttonNoClass = _ref$buttonNoClass === undefined ? 'no' : _ref$buttonNoClass;
	  var _ref$linkAttributeForMessage = _ref.linkAttributeForMessage;
	  var linkAttributeForMessage = _ref$linkAttributeForMessage === undefined ? 'data-message' : _ref$linkAttributeForMessage;
	  var _ref$linkAttributeForYes = _ref.linkAttributeForYes;
	  var linkAttributeForYes = _ref$linkAttributeForYes === undefined ? 'data-yes' : _ref$linkAttributeForYes;
	  var _ref$linkAttributeForNo = _ref.linkAttributeForNo;
	  var linkAttributeForNo = _ref$linkAttributeForNo === undefined ? 'data-no' : _ref$linkAttributeForNo;
	  var _ref$showAlways = _ref.showAlways;
	  var showAlways = _ref$showAlways === undefined ? false : _ref$showAlways;
	  var _ref$onShow = _ref.onShow;
	  var onShow = _ref$onShow === undefined ? function () {} : _ref$onShow;
	  var _ref$onYes = _ref.onYes;
	  var onYes = _ref$onYes === undefined ? function () {} : _ref$onYes;
	  var _ref$onNo = _ref.onNo;
	  var onNo = _ref$onNo === undefined ? function () {} : _ref$onNo;

	  var root = rootManager.getRoot();
	  var localStorage = localStorageManager.getLocalStorage();

	  if (!showAlways && (!localStorage || localStorage.acceptedLanguagesUIDismissedWithNo)) {
	    return;
	  }

	  var currentLanguage = page.getCurrentLanguage();
	  var relevantLanguage = relevant.getRelevantAlternateLanguages()[0];
	  if (!currentLanguage || !relevantLanguage || relevantLanguage == currentLanguage) {
	    return;
	  }
	  var href = page.getHrefForLanguage(relevantLanguage);
	  var link = page.getLinkForLanguage(relevantLanguage);
	  var message = link.getAttribute(linkAttributeForMessage);
	  var yes = link.getAttribute(linkAttributeForYes);
	  var no = link.getAttribute(linkAttributeForNo);

	  var document = root.document;

	  var element = document.querySelector('#' + elementId) || document.createElement(elementTag);
	  element.setAttribute('id', elementId);
	  element.className = elementClass + ' ' + elementClassShow;

	  var text = document.createElement('span');
	  text.innerHTML = '' + message;
	  element.appendChild(text);

	  var buttonNo = createButton(no, buttonNoClass);
	  buttonNo.onclick = function (ev) {
	    if (onNo(ev, currentLanguage, relevantLanguage) === false || ev.defaultPrevented) {
	      return;
	    }
	    element.className = elementClass + ' ' + elementClassHide;
	    localStorage.acceptedLanguagesUIDismissedWithNo = true;
	  };
	  element.appendChild(buttonNo);

	  var buttonYes = createButton(yes, buttonYesClass);
	  buttonYes.onclick = function (ev) {
	    if (onYes(ev, currentLanguage, relevantLanguage) === false || ev.defaultPrevented) {
	      return;
	    }
	    window.location.href = href;
	  };
	  element.appendChild(buttonYes);

	  if (onShow(element, currentLanguage, relevantLanguage) === false) {
	    return;
	  }

	  var elementToInsertInto = document.querySelector(insertElementIntoSelector);
	  if (elementToInsertInto) {
	    if (elementToInsertInto.hasChildNodes()) {
	      elementToInsertInto.insertBefore(element, elementToInsertInto.firstChild);
	    } else {
	      elementToInsertInto.appendChild(element);
	    }
	  }
	}

	;

/***/ },
/* 1 */
/***/ function(module, exports) {

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.getRoot = getRoot;
	exports.setRoot = setRoot;
	var root = window;

	function getRoot() {
	  return root;
	}

	;

	function setRoot(newRoot) {
	  root = newRoot;
	}

/***/ },
/* 2 */
/***/ function(module, exports) {

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.getLocalStorage = getLocalStorage;
	exports.setLocalStorage = setLocalStorage;
	function getBrowserLocalStorage() {
	  if (typeof Storage === "undefined") {
	    return null;
	  }
	  return window.localStorage;
	}

	var localStorage = getBrowserLocalStorage();

	function getLocalStorage() {
	  return localStorage;
	}

	;

	function setLocalStorage(_localStorage) {
	  localStorage = _localStorage;
	}

	;

/***/ }
/******/ ])
});
;