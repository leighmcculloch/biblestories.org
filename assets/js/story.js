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

    $('.story-text-listen').click(function(){
        var startTime = $('.story-text-audio-player audio source:first-child').data('start-time');
        $('.story-text-listen').hide();
        $('.story-text-audio-player').show();
        $('.story-text-audio-player audio').mediaelementplayer({
            loop: true,
            shuffle: false,
            playlist: false,
            enableKeyboard: false,
            audioHeight: 30,
            audioWidth: 200,
            startVolume: 1.0,
            playlistposition: 'bottom',
            features: ['playlistfeature', 'playpause', 'current', 'progress', 'duration'],
            success: function (mediaElement, domObject) {

                mediaElement.addEventListener('loadedmetadata', function(e) {
                    if (typeof startTime != 'undefined' && startTime != 0) {
                        startTime = 0;
                        if (typeof mediaElement != 'undefined') {
                            mediaElement.setCurrentTime(startTime);
                        }
                    }
                }, false);
                mediaElement.play();
            }
        });
    });

});
