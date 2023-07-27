// Manages the application initialization for all pages.
import googleTranslate from './app/util/translation/google-translate';
import alerts from './app/alerts';

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

import 'core-js'
import 'regenerator-runtime/runtime'

import 'uppy/dist/uppy.min.css'

import { multipleFileUpload, singleFileUpload } from './fileUpload'

// Use 'DOMContentLoaded' event if not using Turbolinks
document.addEventListener('turbolinks:load', () => {
  console.log("load");
  document.querySelectorAll(`input[data-uppy="true"]`).forEach((fileInput) => {
    console.log("init uppy");
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
})

import tags from './app/recommended_tags';
import FeedbackForm from './app/FeedbackForm';
import filters from './app/search/filter/search-filters';
import map from './app/result/result-map';
import detailmap from './app/detail/detail-map';
import header from './app/search/header';
import cl from './app/detail/character-limited/character-limiter';
import utilityLinks from './app/detail/utility-links';

document.addEventListener('turbolinks:load', () => {
  // Home
  // Initialize the recommended tag searcher
  const keywordbox = document.getElementById("keyword");
  if (keywordbox) {
    tags.init();
  }
  //Home About
  // Manages initialization of scripts for the About page.
  // Initialize the feedback form
  const feedbackbox = document.getElementById("feedback-box");
  if (feedbackbox) {
    FeedbackForm.create('#feedback-box .feedback-form');
  }

  // Locations Index
  // Initialize the search filters
  const locationIndex = document.getElementsByClassName('locations index');
  if (locationIndex.length > 0) {
    filters.init();
    map.init();
    header.init();
  }


  // Locations Show
  const locationShow = document.getElementsByClassName('locations show');
  if (locationShow.length > 0) {
    detailmap.init();
    cl.init();
    header.init();
    utilityLinks.init();
    filters.init();
  }
})
