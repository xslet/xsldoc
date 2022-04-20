'use strict';

function showHideComparison(switcher) {
  var target = switcher.parentNode.parentNode.querySelector('div.comparison');
  switcher.classList.toggle('to-show');
  switcher.classList.toggle('to-hide');
  target.classList.toggle('show');
  target.classList.toggle('hide');
}

window.addEventListener('DOMContentLoaded', () => {
  const passFailBar = document.getElementById('passFailBar');
  const failIt = document.querySelector('section.it.fail');
  if (failIt) {
    passFailBar.style.backgroundColor = '#f00';
  } else {
    passFailBar.style.backgroundColor = '#0f0';
  }
});
