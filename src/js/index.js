'use strict';

function setupPageTitle() {
  var pageDesc = document.querySelector('div.comment.page-desc');

  var pageDescHtml = pageDesc.innerHTML;
  pageDescHtml = pageDescHtml.replace(/^(<br>)+/, '');

  var foundIndex = pageDescHtml.indexOf('<br>');
  if (foundIndex < 0) {
    if (pageDescHtml) {
      document.title = pageDescHtml;
      pageDesc.innerHTML = '';
    }
    return;
  }

  var fileTitle = pageDescHtml.slice(0, foundIndex).trim();
  var fileSummary = pageDescHtml.slice(foundIndex + '<br>'.length).trim();
  fileSummary = fileSummary.replace(/^(<br>)+/, '');

  document.title = fileTitle;
  document.querySelector('h1').textContent = fileTitle;
  document.querySelector('div.comment.page-desc').innerHTML = fileSummary;
}

module.exports = {
  setupPageTitle: setupPageTitle,
};
