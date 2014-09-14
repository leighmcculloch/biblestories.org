/*!
 * @preserve
 * jquery.ga-playlength.js | v0.2
 * Copyright (c) 2014 Leigh McCulloch
 * Licensed under the BSD 3-clause license.
 *
 * Inspired by and derived from jquery.scrolldepth.js
 * which may be freely distributed under the MIT and GPL licenses.
 * Copyright (c) 2014 Rob Flaherty (@robflaherty).
 */
;(function ( $ ) {

  "use strict";

  var defaults = {
    audioTime: true,
    userTiming: true
  };

  var cache = [],
    lastCurrentTime,
    universalGA,
    classicGA,
    googleTagManager;

  /*
   * Plugin
   */

  $.fn.gaPlayLength = function (options) {
    return this.each(function() {

      var startTime = +new Date;

      options = $.extend({}, defaults, options);

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

          if (options.audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
            lastCurrentTime = currentTime;
            dataLayer.push({'event': 'PlayLength', 'eventCategory': 'Play Length', 'eventAction': 'Audio Time', 'eventLabel': rounded(currentTime), 'eventValue': 1, 'eventNonInteraction': true});
          }

          if (options.userTiming && arguments.length > 3) {
            dataLayer.push({'event': 'PlayTiming', 'eventCategory': 'Play Length', 'eventAction': action, 'eventLabel': label, 'eventTiming': timing});
          }

        } else {

          if (universalGA) {

            ga('send', 'event', 'Play Length', action, label, 1, {'nonInteraction': 1});

            if (options.audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
              lastCurrentTime = currentTime;
              ga('send', 'event', 'Play Length', 'Audio Time', rounded(currentTime), 1, {'nonInteraction': 1});
            }

            if (options.userTiming && arguments.length > 3) {
              ga('send', 'timing', 'Play Length', action, timing, label);
            }

          }

          if (classicGA) {

            _gaq.push(['_trackEvent', 'Play Length', action, label, 1, true]);

            if (options.audioTime && arguments.length > 2 && currentTime > lastCurrentTime) {
              lastCurrentTime = currentTime;
              _gaq.push(['_trackEvent', 'Play Length', 'Audio Time', rounded(currentTime), 1, true]);
            }

            if (options.userTiming && arguments.length > 3) {
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

      /*!
       * @preserve
       * Throttle function borrowed from:
       * Underscore.js 1.5.2
       * http://underscorejs.org
       * (c) 2009-2013 Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
       * Underscore may be freely distributed under the MIT license.
       */

      function throttle(func, wait) {
        var context, args, result;
        var timeout = null;
        var previous = 0;
        var later = function () {
          previous = new Date;
          timeout = null;
          result = func.apply(context, args);
        };
        return function () {
          var now = new Date;
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

      /*
       * Audio Events
       */

      $(this).on('play', function() {
        var key = 'Baseline';
        if ( $.inArray(key, cache) === -1 ) {
          sendEvent('Percentage', key);
          cache.push(key);
        }
      });

      $(this).on('timeupdate', throttle(function () {
        var duration = this.duration;
        var currentTime = this.currentTime;
        if (isNaN(this.duration)) {
          return;
        }

        var marks = calculateMarks(duration);
        var timing = +new Date - startTime;

        $.each(marks, function(key, val) {
          if ( $.inArray(key, cache) === -1 && currentTime >= val ) {
            sendEvent('Percentage', key, currentTime, timing);
            cache.push(key);
          }
        });
      }, 500));

      $(this).on('ended', function () {
        var key = '100%';
        if ( $.inArray(key, cache) === -1 ) {
          var timing = +new Date - startTime;
          sendEvent('Percentage', key, this.duration, timing);
          cache.push(key);
        }
      });

    });
  };



})( jQuery );
