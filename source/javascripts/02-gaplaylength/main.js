/*
 *= require gaplaylength/dist/gaplaylength.min
 */

(function() {
  if (!window.addEventListener) {
    return;
  }

  function load(event){
    window.removeEventListener('load', load, false);

    if (document.body.className.indexOf('story') === -1) {
      return;
    }

    var audio = document.querySelector('.audio-player audio');
    if (audio) {
      gaplaylength.init(audio);
    }
  }

  window.addEventListener('load', load, false);
}());
