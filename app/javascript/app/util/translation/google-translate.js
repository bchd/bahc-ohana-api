// Manages behavior of the Google Website Translator Gadget.
// The google-translate script handles loading of the
// Google Website Translator Gadget at the bottom of the page's body.
// The layout settings passed in as an argument to the initialization
// method can be set to:
// InlineLayout.VERTICAL, InlineLayout.HORIZONTAL,
// which correspond to the 'inline' display modes available through Google.
// The 'tabbed' and 'auto' display modes are not supported.
// The 'inline' InlineLayout.SIMPLE layout is also not supported.

import util from '../util';
import cookie from '../cookie';
import DropDownLayout from '../translation/layout/DropDownLayout';

// The layout object in use.
var _layout;

// The current layout that is set. Determined by the
// 'layout' setting in the Google Translate provided script
// in the footer.
var _layoutType;

// Same 'constants' as google.translate.TranslateElement.InlineLayout
// for tracking which layout is in use.
var VERTICAL = 0;
var HORIZONTAL = 1;
var InlineLayout = { VERTICAL:VERTICAL, HORIZONTAL:HORIZONTAL };

// Checks if the 'googtrans' cookie is set to English or not,
// indicating whether the page has been translated using the
// Google Website Translator Gadget.
// @return [Boolean] true if Google Translation has translated the page.
// Returns false if the page is not translated and is in English.
function isTranslated() {
  var googtrans = cookie.read('googtrans');
  return (googtrans && decodeURIComponent(googtrans) !== '/en/en');
}

// Overwrite/Create Google Website Translator Gadget cookies if the
// 'translate' URL parameter is present.
function _writeTranslateCookies() {
  var translateRequested = util.getParameterByName('translate');
  if (translateRequested) {
    var newCookieValue = '/en/'+translateRequested;
    var oldCookieValue = decodeURIComponent(cookie.read('googtrans'));
    if(newCookieValue !== oldCookieValue) {
      cookie.create('googtrans', newCookieValue, true);
      window.location.reload();
    }
  }
}

// Show any language links that appear on the page.
function _activateLanguageLinks() {
  var links = document.querySelectorAll('.link-translate');
  var numLinks = links.length;
  while( numLinks > 0 ) {
    links[--numLinks].classList.remove('hide');
  }
}

export default {
  isTranslated:isTranslated
};
