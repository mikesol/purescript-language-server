var url = require("url");
exports.uri2path = function (s) {
  return function () {
    return url.fileURLToPath(s);
  };
};

exports.putInPast = function(s) {
  return s.replaceAll("LiveCodeHere", "PutThePastBehindUs");
}