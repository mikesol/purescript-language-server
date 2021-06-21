var uri2path = require('file-uri-to-path');

exports.uri2path = function(s) {
  return function() {
    return uri2path(s);
  }
 }