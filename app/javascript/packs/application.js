import "@hotwired/turbo-rails"
import 'core-js/stable'
import 'regenerator-runtime/runtime'
import 'uppy/dist/uppy.min.css'
import '../add_jquery'
require('../app/app-init')
import { multipleFileUpload, singleFileUpload } from '../fileUpload'

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