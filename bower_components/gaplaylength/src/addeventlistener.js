export default function addEventListener(element, eventName, callback, something) {
  if (element.addEventListener) {
    element.addEventListener(eventName, callback, something);
  } else if (element.attachEvent) {
    element.attachEvent(eventName, callback)
  }
}
