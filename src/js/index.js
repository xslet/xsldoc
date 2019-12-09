'use strict';

function printPageTitle() {
  var fpath = location.href;
  var index = fpath.lastIndexOf('/');
  var fname = (index < 0) ? fpath : fpath.substring(index + 1);
  if (fname.slice(-4) === '.xml') {
    fname = fname.slice(0, -4) + '.xsl';
  }
  var title = fname + ' - API Document';
  document.querySelector('h1').textContent = title;
  document.title = title;
}

module.exports = {
  printPageTitle: printPageTitle,
};
