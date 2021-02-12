const hljs = require("highlight.js/lib/core");
const javascript = require("highlight.js/lib/languages/javascript");
const typescript = require("highlight.js/lib/languages/typescript");
const fs = require("fs");

const styles = fs.readFileSync(
  require.resolve("highlight.js/styles/gruvbox-dark.css"),
  "utf8"
);

hljs.registerLanguage("js", javascript);
hljs.registerLanguage("ts", typescript);

module.exports.highlight = (lang, markup) => {
  return hljs.highlight(lang, markup).value;
};

module.exports.highlight_styles = () => {
  return styles;
};
