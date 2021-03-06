/* custom modernizr tests */
$(function() {
  Modernizr.addTest('mediaqueries', function(){ return !!Modernizr.mq('only all'); });
  Modernizr.addTest('audio-mp3', function(){ return !!Modernizr.audio.mp3; });
  Modernizr.addTest('brokenbrowser', function() {
    var browsers = ['Opera Mini', 'Opera Mobi', 'Opera Tablet'];
    var isBroken = false;
    $.each(browsers, function(index, browser) {
      if (navigator.userAgent.indexOf(browser) != -1) {
        isBroken = true;
      }
    });
    return isBroken;
  });
  if (location.search.indexOf('debug') != -1) {
    alert($('html').get(0).className);
    alert(navigator.userAgent);
  }
});

/* fast click for mobile */
if (document.addEventListener) {
  document.addEventListener('DOMContentLoaded', function() {
    FastClick.attach(document.body);
  }, false);
}

/* language selector */
$(function() {
  $('.language-selector select').change(function() {
    url = $('link[hreflang="' + $(this).val() + '"]').attr('href');
    window.location.href = url;
  });
});

$(window).load(function() {
  $('.language-selector select').autowidth({
    padding: 0,
    maxWidth: 80
  });
  $('.language-selector').css('visibility', 'visible');
});

/* search story list filtering */
$(function() {
    $('.index-searchnoresults').hide();

    $.expr[":"].containsNoCase = function (el, i, m) {
        var search = m[3];
        if (!search) return true;
        var text = $(el).text();
        var data = $(el).data();
        for (var key in data) {
            text += "," + data[key];
        }
        return eval("/" + search + "/i").test(text);
    };

    $('.search form').submit(function (event) {
      event.preventDefault();
    });

    if ($.isCompact()) {
      $('.search .query').focus(function (event) {
        $(window).scrollTop($(this).offset().top - 20);
      });
    }

    $('.search .query').keyup(function (event) {
        /* ESC Key */
        if (event.keyCode == 27) {
            $(this).val('');
        }
        /* Enter Key */
        if (event.keyCode == 13) {
            $(this).blur();
            return;
        }

        var rows_enabled = null;
        var rows_disabled = null;

        if ($(this).val().length == 0) {
            rows_enabled = $('.stories .story');
            rows_disabled = $([]);
        } else {
            rows_enabled = $('.stories .story:containsNoCase("' + $(this).val() + '")');
            rows_disabled = $('.stories .story:not(:containsNoCase("' + $(this).val() + '"))');
        }

        rows_enabled.show();
        rows_disabled.hide();

        if (rows_enabled.length == 0) {
            $('.search-no-results').show();
        }
        else {
            $('.search-no-results').hide();
        }
    });
});
