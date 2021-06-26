var url = require("url");
exports.uri2path = function (s) {
  return function () {
    return url.fileURLToPath(s);
  };
};
