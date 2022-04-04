
import "@hotwired/turbo-rails"
import 'core-js/stable'
import 'regenerator-runtime/runtime'

import 'uppy/dist/uppy.min.css'
import '../add_jquery'

import { multipleFileUpload, singleFileUpload } from '../fileUpload'
// require('../app/app-init');

// Use 'DOMContentLoaded' event if not using Turbolinks (now Turbo)
document.addEventListener('turbo:load', () => {
  document.querySelectorAll(`input[data-uppy=${true}]`).forEach((fileInput) => {
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
})
