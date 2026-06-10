// Drives the cart preview page (/cart/preview): removing a listing from the
// cart and reflecting an emptied cart in the UI. The listings themselves are
// server-rendered; this only handles the interactive bits. Cart persistence
// lives in app/javascript/app/cart/pdf-cart.js.
import cart from './pdf-cart';

// Remove the clicked listing from the cart cookie and from the page.
function _onClick(e) {
  const button = e.target.closest('.preview-card__remove');
  if (!button) { return; }

  cart.remove(button.dataset.locationId);

  const item = button.closest('.cart-preview__item');
  if (item) { item.remove(); }

  _reflectEmptyState();
}

// Once the last listing is removed, swap the list/footer for the empty message.
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
