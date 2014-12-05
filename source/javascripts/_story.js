/* side menu */
$(function() {
    $('.toggle-side-menu-and-search').click(function() {
      toggleSideMenuAndSearch();
    });
    $('.toggle-side-menu').click(function() {
      toggleSideMenu();
    });
    $('.side-menu').hover(function() {
      timeoutId = setTimeout(showSideMenu, 150);
      window.sideMenuTimeoutIds = (window.sideMenuTimeoutIds||[]).concat(timeoutId);
    }, function() {
      $.each(window.sideMenuTimeoutIds, function(index, timeoutId) {
        clearTimeout(timeoutId);
      });
      hideSideMenu();
    });
    $('.toggle-verses').click(function() {
      $('.text').toggleClass('show-verses');
    });
});

function toggleSideMenuAndSearch() {
  $('.search .query').focus();
  toggleSideMenu();
}

function toggleSideMenu() {
  if (isShowingSideMenu()) {
    hideSideMenu();
  } else {
    showSideMenu();
  }
}

function isShowingSideMenu() {
  return $('.page').hasClass('showing-side-menu');
}

function showSideMenu() {
  $('.side-menu').scrollTop(0);
  $('.page').addClass('showing-side-menu');
}

function hideSideMenu() {
  $('.page').removeClass('showing-side-menu');
}

/* share buttons */
var addthis_config = {
  // data_ga_property: 'UA-123456-1',
  data_track_addressbar: false,
  data_track_clickback: false
};
var addthis_share = {
  url: window.location.href
};
$(window).ready(function() {
  $.ajax({
    url: '//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-538af91b78db2c14',
    cache: true,
    async: true,
    dataType: 'script'
  });
});

/* zoom */
$(function() {
  var $storyText = $('.story .text');
  $('.zoom-smaller').click(function () {
    $storyText.css('font-size', parseFloat($storyText.css('font-size'), 10)/1.2);
    return false;
  });
  $('.zoom-larger').click(function () {
    $storyText.css('font-size', 1.2*parseFloat($storyText.css('font-size'), 10));
    return false;
  });
});

/* audio and audio analytics */
var audio = $('.audio-player audio').get(0);
if (typeof audio != 'undefined') {
  var $control = $('.controls .audio-label, .controls .audio');
  if (!!(audio.canPlayType && audio.canPlayType('audio/mpeg;').replace(/no/, ''))) {
    $(audio).gaPlayLength({
      audioTime: true,
      userTiming: true
    });
    $control.click(function(ev){
      ev.preventDefault();
      $('.audio-player').show();
      if (typeof audio != 'undefined') {
        audio.addEventListener('canplay', function(e) {
          audio.play();
        }, false);
        audio.load();
      }
    });
  } else {
    $control.click(function(ev){
        ga('send', 'event', 'Listen', 'direct');
    });
  }
}

/* scroll depth analytics */
$.scrollDepth();