'use strict';

function showHideComparison(switcher) {
  var target = switcher.parentNode.parentNode.querySelector('div.comparison');
  switcher.classList.toggle('to-show');
  switcher.classList.toggle('to-hide');
  target.classList.toggle('show');
  target.classList.toggle('hide');
}
