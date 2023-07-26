// Manages the application initialization for all pages.

import googleTranslate from './util/translation/google-translate';
import alerts from './alerts';

// The google-translate script handles loading of the
// Google Website Translator Gadget at the bottom of the page's body.
// The layout settings passed in as an argument to the initialization
// method can be set to:
// InlineLayout.VERTICAL, InlineLayout.HORIZONTAL,
// which correspond to the 'inline' display modes available through Google.
// The 'tabbed' and 'auto' display modes are not supported.
// The 'inline' InlineLayout.SIMPLE layout is also not supported.
document.addEventListener('turbolinks:load', () => {
  googleTranslate.init(googleTranslate.InlineLayout.VERTICAL)
  alerts.init();
})
