// Manages the "Add to PDF" cart: the set of selected location IDs, persisted in a
// cookie so the selection survives navigation between the locations index and show pages.
// Selection logic for the cart banner count and every `.add-to-cart` toggle button lives here.
import cookie from '../util/cookie';

const COOKIE_NAME = 'pdf_cart';
// Days until the cart cookie expires (keeps a selection across short browsing sessions).
const COOKIE_DAYS = 1;

// Read the selected location IDs (as strings) from the cookie.
// @return [Array<String>] The selected location IDs, or an empty array.
function _read() {
  const raw = cookie.read(COOKIE_NAME);
  if (!raw) { return []; }

  try {
    const parsed = JSON.parse(decodeURIComponent(raw));
    return Array.isArray(parsed) ? parsed.map(String) : [];
  } catch (e) {
    return [];
  }
}

// Persist the selected location IDs to the cookie.
// @param ids [Array<String>] The selected location IDs.
function _write(ids) {
  cookie.create(COOKIE_NAME, encodeURIComponent(JSON.stringify(ids)), false, COOKIE_DAYS);
}

// Reflect a single button's selected/unselected state in the DOM.
// @param button [Element] The `.add-to-cart` button.
// @param selected [Boolean] Whether its location is in the cart.
function _setButtonState(button, selected) {
  button.classList.toggle('is-selected', selected);
  button.setAttribute('aria-pressed', selected ? 'true' : 'false');

  const name = button.dataset.locationName || 'this listing';
  button.setAttribute('aria-label', selected ? `Remove ${name} from PDF` : `Add ${name} to PDF`);
}

// Reflect the current selection across the page: each cart banner's count/preview
// button and every add-to-cart toggle. Safe to call when no cart elements exist.
function sync() {
  const ids = _read();

  document.querySelectorAll('.cart-banner').forEach((banner) => {
    const count = banner.querySelector('.cart-banner__count');
    if (count) { count.textContent = ids.length; }

    const preview = banner.querySelector('.cart-banner__preview');
    if (preview) { preview.disabled = ids.length === 0; }
  });

  document.querySelectorAll('.add-to-cart').forEach((button) => {
    _setButtonState(button, ids.indexOf(String(button.dataset.locationId)) !== -1);
  });
}

// Remove a single location from the cart and re-sync the UI.
// @param id [String|Number] The location ID to remove.
function remove(id) {
  const target = String(id);
  _write(_read().filter((existing) => existing !== target));
  sync();
}

// Toggle a location in/out of the cart when its button is clicked.
// Uses event delegation so buttons added later (e.g. after an AJAX filter) still work.
function _onClick(e) {
  const button = e.target.closest('.add-to-cart');
  if (!button) { return; }

  e.preventDefault();

  const id = String(button.dataset.locationId);
  let ids = _read();

  if (ids.indexOf(id) !== -1) {
    ids = ids.filter((existing) => existing !== id);
  } else {
    ids.push(id);
  }

  _write(ids);
  sync();
}

// Whether the delegated click listener has been attached. The module persists across
// Turbo navigations, so we only ever bind once.
let _bound = false;

// Send the user to the preview page when an enabled banner "Preview" button is
// clicked. The banner is server-rendered and never swapped out, so a direct
// listener fits (no delegation needed); the dataset guard keeps a repeat init()
// on the same DOM from binding twice.
function _bindPreview() {
  document.querySelectorAll('.cart-banner__preview').forEach((button) => {
    if (button.dataset.previewBound) { return; }
    button.dataset.previewBound = 'true';

    button.addEventListener('click', () => {
      if (!button.disabled) { window.location.href = '/cart/preview'; }
    });
  });
}

// Wire up the cart: attach the (one-time) click listener and sync the current state.
function init() {
  if (!_bound) {
    document.addEventListener('click', _onClick);
    _bound = true;
  }

  _bindPreview();
  sync();
}

export default {
  init: init,
  sync: sync,
  remove: remove
};
