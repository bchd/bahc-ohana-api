// Drives the cart preview page (/cart/preview): removing a listing from the
// cart, downloading the selected listings as a PDF, and reflecting an emptied
// cart in the UI. The listings themselves are server-rendered; this only
// handles the interactive bits. Cart persistence lives in
// app/javascript/app/cart/pdf-cart.js.
import cart from './pdf-cart';

const DOWNLOAD_URL = '/cart/download';
const DOWNLOAD_FILENAME = 'selected-services.pdf';

// Remove the clicked listing from the cart cookie and from the page.
function _onRemoveClick(e) {
  const button = e.target.closest('.preview-card__remove');
  if (!button) { return; }

  cart.remove(button.dataset.locationId);

  const item = button.closest('.cart-preview__item');
  if (item) { item.remove(); }

  _reflectEmptyState();
}

// Fetch the PDF and hand it to the browser as a download. The server clears the
// cart cookie in the response, so we only clear it again (and empty the page)
// once the download has actually succeeded.
function _onDownloadClick(e) {
  const button = e.target.closest('#cart-preview-download');
  if (!button) { return; }

  button.disabled = true;

  fetch(DOWNLOAD_URL, { credentials: 'same-origin' })
    .then((response) => {
      if (!response.ok) { throw new Error(`Download failed: ${response.status}`); }
      return response.blob();
    })
    .then((blob) => {
      _saveBlob(blob, DOWNLOAD_FILENAME);
      cart.clear();

      // The selection has been downloaded and cleared, so drop every listing
      // from the page and show the empty message.
      const list = document.getElementById('cart-preview-list');
      if (list) {
        list.querySelectorAll('.cart-preview__item').forEach((item) => item.remove());
      }
      _reflectEmptyState();
    })
    .catch(() => {
      button.disabled = false;
    });
}

// Trigger a browser download for a blob via a transient anchor element.
function _saveBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}

function _onClick(e) {
  _onRemoveClick(e);
  _onDownloadClick(e);
}

// Once the last listing is removed (or the cart is downloaded), swap the
// list/footer for the empty message.
function _reflectEmptyState() {
  const list = document.getElementById('cart-preview-list');
  if (!list || list.querySelector('.cart-preview__item')) { return; }

  list.hidden = true;

  const footer = document.getElementById('cart-preview-footer');
  if (footer) { footer.hidden = true; }

  const empty = document.getElementById('cart-preview-empty');
  if (empty) { empty.hidden = false; }
}

let _bound = false;

function init() {
  if (!_bound) {
    document.addEventListener('click', _onClick);
    _bound = true;
  }
}

export default {
  init: init
};
