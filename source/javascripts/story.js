/*
 *= require _jquery-1.11.1.min
 */

$(function() {
    $('.toggle-side-menu').click(function() {
        toggleSideMenu();
    });
});

function toggleSideMenu() {
  if ($('.wrapper').hasClass('show-side-menu')) {
    $('.wrapper').removeClass('show-side-menu');
  } else {
    $('.wrapper').addClass('show-side-menu');
  }
}

var addthis_config = {
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
