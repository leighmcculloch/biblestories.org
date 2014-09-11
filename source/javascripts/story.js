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