// Handles freeform text input search filters.
import eventObserver from '../../util/EventObserver';

function create(id) {
  return new TextInput(id);
}

function TextInput(id) {
  var _instance = this;

  // The events this instance broadcasts.
  var _events = { CHANGE: 'change' };
  eventObserver.attach(this);

  // The container HTML element for this text input.
  var _container = document.querySelector('#' + id + ' .clearable');

  // The clear text button (x) HTML.
  var _buttonClear;

  // The actual text input to clear.
  var _input;

  function reset() {
    // _buttonClear.classList.add('hide');
    // _input.value = '';
  }

  function _initClearButton() {
  }

  // Hide the clear button if there isn't any input text,
  // otherwise show it.
  function _setClearButtonVisibility() {
    // if (_input.value === '')
    //   // _buttonClear.classList.add('hide');
    // else
    //   // _buttonClear.classList.remove('hide');
  }

  function _throwInitializationError() {
    var message = 'A clearable Text Input with id "' +
                  id + '" was not initialized!';
    throw new Error(message);
  }

  // Initialize TextInput instance.
  _initClearButton();

  _instance.reset = reset;

  return _instance;
}

export default {
  create:create
};
