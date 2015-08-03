/*
 *= require acceptedlanguages/dist/acceptedlanguages.min
 *= require acceptedlanguagesui/dist/acceptedlanguagesui.min
 */

(function() {
  if (!window.addEventListener) {
    return;
  }

  function load(event){
    window.removeEventListener("load", load, false);
    if (document.body.className.indexOf('story') != -1) {
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
    }
  }

  window.addEventListener("load", load, false);
}());
