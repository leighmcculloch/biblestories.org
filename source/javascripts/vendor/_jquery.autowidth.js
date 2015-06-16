// Based on http://stackoverflow.com/questions/20091481/auto-resizing-the-select-element-according-to-selected-options-width
// Licensed as CC0 or public domain, whatever you prefer.
 
;(function($, undefined) {   
  var pluginName = 'autowidth',
    defaults = {
            maxWidth: null,
            minWidth: null,
      padding: 30
    };
 
    function Plugin(element, options) {
        if($(element).is('select')) {        
            this.element = element;
            this.settings = $.extend( {}, defaults, options );
            this._defaults = defaults;
            this._name = pluginName;
            this.init();
        }
    }
 
    $.extend(Plugin.prototype, {
        init: function () {
            var self = this;
            
            $(self.element).change(function() {                
                self.changeWidth(self.element);    
            });
            
            self.changeWidth(self.element);
        },
        
        changeWidth: function (select) {
            var span = $('<span display="none">'+$('option:selected', select).text()+'</span>')
                    .css({
            font:   $(select).css('font'),
            padding:  $(select).css('padding')
          })
                    .appendTo('body'),
                width = span.width() + this.settings.padding;
            
            span.remove();
            
            if (this.settings.maxWidth !== null && width > this.settings.maxWidth) {
                width = this.settings.maxWidth;
            }
            
            if (this.settings.minWidth !== null && width < this.settings.minWidth) {
                width = this.settings.minWidth;
            }
            
            $(select).width(width);
        }
    });
 
  $.fn[pluginName] = function (options) {
    this.each(function() {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName, new Plugin(this, options));
            }
        });
 
    return this;
  };
})(jQuery);
