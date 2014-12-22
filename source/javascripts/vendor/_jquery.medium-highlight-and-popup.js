/*
 * Medium Highlight and Popup jQuery Plugin
 * 
 * Author: Leigh McCulloch
 * Copyright Leigh McCulloch
 * MIT | BSD License
 * 
 * Inspired by Highlighter.js 1.0 by Matthew Conlen <matt.conlen@huffingtonpost.com> of Huffington Post Labs,
 * which provided much of the learnings for how to develop this highlighting plugin with different behavior.
 */

(function ($) {

  var methods = {
    init: function (options) {

      var settings = $.extend({
        selector: '.highlighter-container',
        minChars: 0,
        complete: function() {}
      }, options);
      var isDown = false;
      var selectionCheckTimerId = null;
      var thisElement = this;

      return this.each(function () {
        function getSelectionText() {
          var top = 0, left = 0, width = 0, height = 0;
          if (window.getSelection) {
            var selection = window.getSelection();
            if (selection) {
              if (selection.rangeCount) {
                var range = selection.getRangeAt(0);
                var startContainer = range.startContainer;
                if (startContainer) {
                  var parentNode = startContainer.parentNode;
                  if (parentNode) {
                    if ($.contains($(thisElement).get(0), parentNode)) {
                      return selection.toString();
                    }
                  }
                }
              }
            }
          }
          return "";
        }
        function getPageOffset() {
          var top, left;
          
          if (typeof window.pageYOffset === 'number') {
            top = window.pageYOffset;
            left = window.pageXOffset;
          } else {
            var documentElement = null;
            if (document.compatMode && document.compatMode === 'CSS1Compat') {
              documentElement = document.documentElement;
            } else {
              documentElement = document.body;
            }
            top = documentElement.scrollTop;
            left = documentElement.scrollLeft;
          }
          return { top: top, left: left };
        }
        function getSelectionDimensions() {
          var selection = null, range;
          var top = 0, left = 0, width = 0, height = 0;
          if (window.getSelection) {
            selection = window.getSelection();
            if (selection.rangeCount) {
              range = selection.getRangeAt(0).cloneRange();
              if (range.getBoundingClientRect) {
                var rect = range.getBoundingClientRect();
                top = rect.top;
                left = rect.left;
                width = rect.right - rect.left;
                height = rect.bottom - rect.top;
              }
            }
          }
          var pageOffset = getPageOffset();
          top += pageOffset.top;
          left += pageOffset.left;
          return { top: top, left: left, width: width, height: height };
        }

        function activatePopup() {
          var $popup = $(settings.selector);
          var selection = getSelectionDimensions();
          $(settings.selector).hide(0, function() {
            var top = selection.top - $popup.height();
            var left = selection.left + selection.width / 2.0 - $popup.width() / 2.0;
            $(settings.selector).css('top', top + 'px');
            $(settings.selector).css('left', left + 'px');
            $(settings.selector).show(0, function() {
              settings.complete(getSelectionText());
            });
          });
        }

        $(settings.selector).hide();
        $(settings.selector).css('position', 'absolute');
        setInterval(function() {
          var selectionText = getSelectionText();
          if (isDown || selectionText.length < settings.minChars) {
            $(settings.selector).hide();
          } else {
            activatePopup();
          }
        }, 400);
        $(document).bind('mouseup.highlighter', function (e) {
          if (isDown) {
            isDown = false;
          }
        });
        $(this).bind('mousedown.highlighter', function (e) {
          isDown = true;
        });
      });
    },
    destroy: function (content) {
      return this.each(function () {
        $(document).unbind('mouseup.highlighter');
        $(this).unbind('mousedown.highlighter');
      });
    }
  };

  /*
   * Method calling logic taken from the
   * jQuery article on best practices for
   * plugins.
   *
   * http://docs.jquery.com/Plugins/Authoring
   */
  $.fn.highlightAndPopup = function (method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist on jQuery.highlightAndPopup');
    }

  };

})(jQuery);