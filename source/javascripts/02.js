/*
 *= require acceptedlanguages/dist/acceptedlanguages.min
 *= require acceptedlanguagesui/dist/acceptedlanguagesui.min
 *= require gascrolldepth/gascrolldepth.min
 *= require gaplaylength/dist/gaplaylength.min
 */

(function() {
  if (!window.addEventListener) {
    return;
  }

  window.addEventListener("load", function() {
    if (document.body.className.indexOf('story') != -1) {

      /* acceptedlanguagesui */
      acceptedlanguagesui.init({
        insertElementIntoSelector: '.side-menu-view-container',
        onShow: function(element, currentLanguage, relevantLanguage) {
          ga('send', 'event', 'acceptedlanguagesui', 'show', currentLanguage + '→' + relevantLanguage, {'nonInteraction': 1});
        },
        onYes: function(ev, currentLanguage, relevantLanguage) {
          ga('send', 'event', 'acceptedlanguagesui', 'yes', currentLanguage + '→' + relevantLanguage);
        },
        onNo: function(ev, currentLanguage, relevantLanguage) {
          ga('send', 'event', 'acceptedlanguagesui', 'no', currentLanguage + '→' + relevantLanguage);
        },
      });

      /* scroll depth analytics */
      gascrolldepth.init();

      /* audio play analytics */
      var audio = document.querySelector('.audio-player audio');
      if (audio) {
        gaplaylength.init(audio);
      }

    }
  }, false);

}());
