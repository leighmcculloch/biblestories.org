/* side menu */
$(function() {
    $('.toggle-side-menu')
      .click(function() {
        toggleSideMenu();
      })
      /*.bind('touchstart', function() {
        toggleSideMenu();
      })*/;
});

function toggleSideMenu() {
  if ($('.wrapper').hasClass('show-side-menu')) {
    $('.wrapper').removeClass('show-side-menu');
  } else {
    $('.wrapper').addClass('show-side-menu');
  }
}

/* share buttons */
var addthis_config = {
  data_ga_property: 'UA-123456-1',
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