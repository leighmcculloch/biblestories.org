export function expandLanguages(languages) {
  var expanded = {};
  languages.forEach(function(language){
    expanded[language] = language;
    var code = language.match(/^[a-zA-Z]+/)[0];
    if (code != language && !expanded[code]) {
      expanded[code] = language;
    }
  });
  return expanded;
};
