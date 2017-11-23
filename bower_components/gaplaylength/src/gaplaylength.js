/*!
 * gaplaylength.js | v0.3
 * Copyright (c) 2015 Leigh McCulloch
 * Licensed under the ICS license.
 *
 * Inspired by and derived from jquery.scrolldepth.js
 * which may be freely distributed under the MIT and GPL licenses.
 * Copyright (c) 2014 Rob Flaherty (@robflaherty).
 */

import addEventListener from 'addeventlistener';
import throttle from 'throttle'

export function init(element, {
  audioTime = true,
  userTiming = true
} = {}) {
  var universalGA;
  var classicGA;
  var googleTagManager;

  var cache = [];
  var startTime = +new Date;
  var lastCurrentTime;

  /*
   * Determine which version of GA is being used
   * "ga", "_gaq", and "dataLayer" are the possible globals
   */

  if (typeof ga === "function") {
    universalGA = true;
  }

  if (typeof _gaq !== "undefined" && typeof _gaq.push === "function") {
    classicGA = true;
  }

  if (typeof dataLayer !== "undefined" && typeof dataLayer.push === "function") {
    googleTagManager = true;
  }

  /*
   * Functions
   */

  function sendEvent(action, label, currentTime, timing) {

    if (googleTagManager) {

      dataLayer.push({'event': 'PlayLength', 'eventCategory': 'Play Length', 'eventAction': action, 'eventLabel': label, 'eventValue': 1, 'eventNonInteraction': true});

      if (audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
        lastCurrentTime = currentTime;
        dataLayer.push({'event': 'PlayLength', 'eventCategory': 'Play Length', 'eventAction': 'Audio Time', 'eventLabel': rounded(currentTime), 'eventValue': 1, 'eventNonInteraction': true});
      }

      if (userTiming && arguments.length > 3) {
        dataLayer.push({'event': 'PlayTiming', 'eventCategory': 'Play Length', 'eventAction': action, 'eventLabel': label, 'eventTiming': timing});
      }

    } else {

      if (universalGA) {

        ga('send', 'event', 'Play Length', action, label, 1, {'nonInteraction': 1});

        if (audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
          lastCurrentTime = currentTime;
          ga('send', 'event', 'Play Length', 'Audio Time', rounded(currentTime), 1, {'nonInteraction': 1});
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
    return (Math.floor(currentTime/10) * 10).toString();
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
    var timing = +new Date - startTime;

    for(var key in marks) {
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
      var timing = +new Date - startTime;
      sendEvent('Percentage', key, element.duration, timing);
      cache.push(key);
    }
  }

  /*
   * Audio Events
   */

  addEventListener(element, 'play', onPlay, false);
  addEventListener(element, 'timeupdate', throttle(onTimeUpdate, 500), false);
  addEventListener(element, 'ended', onEnded, false);

};
