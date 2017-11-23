import * as rootManager from 'acceptedlanguagesui-root';
import * as localStorageManager from 'acceptedlanguagesui-localStorage';

var page = acceptedlanguages.lib.page;
var relevant = acceptedlanguages.lib.relevant;

function createButton(text, cssClass) {
  var button = document.createElement('button');
  button.setAttribute('type', 'button');
  button.className = cssClass;
  button.innerHTML = text;
  return button;
}

export function init({
  insertElementIntoSelector = 'body',
  elementTag = 'div',
  elementId = 'acceptedlanguagesui',
  elementClass = 'acceptedlanguagesui',
  elementClassShow = 'show',
  elementClassHide = 'hide',
  buttonYesClass = 'yes',
  buttonNoClass = 'no',
  linkAttributeForMessage = 'data-message',
  linkAttributeForYes = 'data-yes',
  linkAttributeForNo = 'data-no',
  showAlways = false,
  onShow = function() {},
  onYes = function() {},
  onNo = function() {}
} = {}) {
  var root = rootManager.getRoot();
  var localStorage = localStorageManager.getLocalStorage();

  if (!showAlways && (!localStorage || localStorage.acceptedLanguagesUIDismissedWithNo)) {
    return;
  }

  var currentLanguage = page.getCurrentLanguage();
  var relevantLanguage = relevant.getRelevantAlternateLanguages()[0];
  if (!currentLanguage || !relevantLanguage || relevantLanguage == currentLanguage) {
    return;
  }
  var href = page.getHrefForLanguage(relevantLanguage);
  var link = page.getLinkForLanguage(relevantLanguage);
  var message = link.getAttribute(linkAttributeForMessage);
  var yes = link.getAttribute(linkAttributeForYes);
  var no = link.getAttribute(linkAttributeForNo);

  var document = root.document;

  var element = document.querySelector(`#${elementId}`) || document.createElement(elementTag);
  element.setAttribute('id', elementId);
  element.className = `${elementClass} ${elementClassShow}`;

  var text = document.createElement('span')
  text.innerHTML = `${message}`;
  element.appendChild(text);

  var buttonNo = createButton(no, buttonNoClass);
  buttonNo.onclick = function(ev) {
    if (onNo(ev, currentLanguage, relevantLanguage) === false || ev.defaultPrevented) {
      return;
    }
    element.className = `${elementClass} ${elementClassHide}`;
    localStorage.acceptedLanguagesUIDismissedWithNo = true;
  };
  element.appendChild(buttonNo);

  var buttonYes = createButton(yes, buttonYesClass);
  buttonYes.onclick = function(ev) {
    if (onYes(ev, currentLanguage, relevantLanguage) === false || ev.defaultPrevented) {
      return;
    }
    window.location.href = href;
  };
  element.appendChild(buttonYes);

  if (onShow(element, currentLanguage, relevantLanguage) === false) {
    return;
  }

  var elementToInsertInto = document.querySelector(insertElementIntoSelector);
  if (elementToInsertInto) {
    if (elementToInsertInto.hasChildNodes()) {
      elementToInsertInto.insertBefore(element, elementToInsertInto.firstChild);
    } else {
      elementToInsertInto.appendChild(element);
    }
  }
};
