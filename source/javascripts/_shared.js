/* fast click for mobile */
$(function() {
  FastClick.attach(document.body);
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
