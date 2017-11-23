function getBrowserLocalStorage() {
  if(typeof(Storage) === "undefined") {
    return null;
  }
  return window.localStorage;
}

var localStorage = getBrowserLocalStorage();

export function getLocalStorage() {
  return localStorage;
};

export function setLocalStorage(_localStorage) {
  localStorage = _localStorage;
};
