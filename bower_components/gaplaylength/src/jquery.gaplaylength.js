import * as module from 'gaplaylength';

jQuery.fn.gaPlayLength = function(options) {
  return this.each(function() {
    module.init(this, options);
  });
};
