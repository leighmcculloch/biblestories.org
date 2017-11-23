# gaplaylength
A Google Analytics plugin that measures engagement with audio/video content by tracking how much of a HTML5 audio/video player a visitor plays. The plugin supports Universal Analytics, Classic Google Analytics, and Google Tag Manager.

The following time portions are reported:
* Baseline — triggered when playing
* 10%
* 50%
* 75%
* 100% — triggered when the playing ends

The above items are only triggered once for the audio/video element.

## Usage
Include this library after your Google Analytics tracking snippet.

	<script src="gaplaylength.min.js"></script>
	<script>
	var element = document.querySelector('audio,video');
	gaplaylength.init(element, {
		/* audioTime: if true, the time in seconds of the
		 * audio will be included with the event. Default: true */
		    audioTime: true,
		/* userTiming: if true, the time in seconds since page load
		 * will be included in the event. Default: true */
		    userTiming: true
	});
	</script>

## Usage with jQuery
Include this library after your Google Analytics tracking snippet, and jQuery.

	<script src="jquery.gaplaylength.min.js"></script>
	<script>
	$(function() {
		$('audio').gaPlayLength({
			/* audioTime: if true, the time in seconds of the
			 * audio will be included with the event. Default: true */
	        audioTime: true,
			/* userTiming: if true, the time in seconds since page load
			 * will be included in the event. Default: true */
	        userTiming: true
	    });
	});
	</script>


## Example
See [example/index.html](example/index.html) and [example-jquery/index.html](example-jquery/index.html).

## Thanks
Thanks to Rob Flaherty ([@robflaherty](https://twitter.com/robflaherty)) who created [jquery-scrolldepth](https://github.com/robflaherty/jquery-scrolldepth), which this library is inspired by.

## License
Licensed under the BSD 3-clause license, see `license.md`. See `jquery.ga-playlength.js` for dependency licenses.
