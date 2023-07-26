require('turbolinks').start()
require('./app/app-init');

import 'core-js'
import 'regenerator-runtime/runtime'

import 'uppy/dist/uppy.min.css'

import { multipleFileUpload, singleFileUpload } from './fileUpload'

// Use 'DOMContentLoaded' event if not using Turbolinks
document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll(`input[data-uppy=${true}]`).forEach((fileInput) => {
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
})

// Home
import tags from './app/recommended_tags';
// Initialize the recommended tag searcher
const keywordbox = document.getElementById("#keyword");
if (keywordbox) {
  tags.init();
}

//Home About
// Manages initialization of scripts for the About page.
import FeedbackForm from './app/FeedbackForm';
// Initialize the feedback form
const feedbackbox = document.getElementById("#feedback-box");
if (feedbackbox) {
  FeedbackForm.create('#feedback-box .feedback-form');
}

// Locations Index
import filters from './app/search/filter/search-filters';
import map from './app/result/result-map';
import header from './app/search/header';
// Initialize the search filters
const locationIndex = document.getElementByClassName('locations index');
if (locationIndex.length > 0) {
  filters.init();
  map.init();
  header.init();
}


// Locations Show
import cl from './app/detail/character-limited/character-limiter';
import utilityLinks from './app/detail/utility-links';
const locationShow = document.getElementByClassName('locations show');
if (locationShow.length > 0) {
  map.init();
  cl.init();
  header.init();
  utilityLinks.init();
  filters.init();
}
