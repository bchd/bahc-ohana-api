require('turbolinks').start()

import 'core-js/stable'
import 'regenerator-runtime/runtime'

import { multipleFileUpload, singleFileUpload } from 'fileUpload'

// Use 'DOMContentLoaded' event if not using Turbolinks
document.addEventListener('turbolinks:load', () => {
  console.log('loaded 🥃')
  document.querySelectorAll('input[type=file]').forEach((fileInput) => {
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
})
