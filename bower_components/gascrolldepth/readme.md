# Scroll Depth
Scroll Depth is a Google Analytics plugin that tracks how far users are scrolling. The plugin provides native support for Universal Analytics, Classic Google Analytics, and Google Tag Manager. It can also be used with any analytics service that supports events.

This fork is maintained in parallel with Robert Flaherty's `jquery-scrolldepth` project, removing the dependence on jQuery.

## Install
```
bower install gascrolldepth
```

## Usage
```javascript
gascrolldepth.init();
```

or with jQuery:
```javascript
$.gascrolldepth();
```

## Browser Compatibility

When specifying elements by their selector, browser compatibility is as follows, due to use of `document.querySelector` to find the element.

| Browser                   | Minimum Verison |
|:------------------------- |:---------------:|
| Chrome                    | 4
| Firefox                   | 3.5
| Internet Explorer         | 8
| Opera                     | 10.1
| Safari                    | 3.1
| iOS Safari                | 3.2
| Opera Mini                | 8
| Blackberry Browser        | 7
| Opera Mobile              | 12
| Chrome for Android        | 42
| Firefox for Android       | 39
| IE Mobile                 | 10
| UC Browser for Android    | 9.9

To expand browser compatibility to all effective browsers (IE 6+, Chrome 1+, Safari 1+, Firefox 2+, etc), you can:
* include jQuery and all selectors supported by jQuery will be supported.
* or, specify `elements` as an array of element IDs only, eg. `#main` and it will fallback to `document.getElementById`;
* or, specify `elements` as an array of `DOMElement` objects rather than string selectors.

## Contributing
Bug reports and code contributions are welcome. Please see [contributing.md](https://github.com/robflaherty/jquery-scrolldepth/blob/master/contributing.md).

## Testing
There's a test HTML file that mocks the Google Analytics functions and writes the GA Event data to the console.

## License
Licensed under the MIT and GPL licenses.

