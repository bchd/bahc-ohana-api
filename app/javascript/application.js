// Manages the application initialization for all pages.
import alerts from './app/alerts';

import 'core-js'
import 'regenerator-runtime/runtime'

import 'uppy/dist/uppy.min.css'

import { multipleFileUpload, singleFileUpload } from './fileUpload'

import tags from './app/recommended_tags';
import FeedbackForm from './app/FeedbackForm';
import filters from './app/search/filter/search-filters';
import map from './app/result/result-map';
import detailmap from './app/detail/detail-map';
import header from './app/search/header';
import cl from './app/detail/character-limited/character-limiter';
import utilityLinks from './app/detail/utility-links';

document.addEventListener('turbolinks:load', () => {
  // clean up old translate entries
  document.getElementById('google-translate-container').innerHTML = '';

  // All pages alerts init
  alerts.init();

  // Admin File Upload
  document.querySelectorAll(`input[data-uppy="true"]`).forEach((fileInput) => {
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
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
