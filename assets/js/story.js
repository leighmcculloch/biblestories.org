$(document).ready(function() {

    $('.story-text-smaller,.story-text-larger').hover(function() {
        $(this).css('cursor','pointer');
    });
    $('.story-text-smaller').click(function () {
        $('.story-passage').css('font-size', (1/1.2)*parseFloat($('.story-passage').css('font-size'), 10));
        return false;
    });
    $('.story-text-larger').click(function () {
        $('.story-passage').css('font-size', 1.2*parseFloat($('.story-passage').css('font-size'), 10));
        return false;
    });

    $('.story-passage p')
        /* verse highlighting */
        .wrapInner('<span class="highlightable"></span>')
        /* verse number showing - crossway, biblesorg */
        .hover(function() {
                $(this).find('span.verse-num,span.chapter-num,sup.v').css('color','#000');
            }, function() {
                $(this).find('span.verse-num,span.chapter-num,sup.v').css('color','#eee');
            }
        );


    var $audio = $('.story-text-audio-player audio').get(0);
    if (typeof $audio != 'undefined') {
        if (!!($audio.canPlayType && $audio.canPlayType('audio/mpeg;').replace(/no/, ''))) {
            $('.story-text-listen').click(function(ev){
                ev.preventDefault();
                $('.story-text-listen').hide();
                $('.story-text-audio-player').show();
                if (typeof $audio != 'undefined') {
                    $audio.addEventListener('canplay', function(e) {
                        $audio.play();
                    }, false);
                    $audio.load();
                }
            });
        }
    }


});
