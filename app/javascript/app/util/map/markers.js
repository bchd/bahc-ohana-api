// Used for managing which map marker should be shown.
import BitMask from '../BitMask'; 

// 'Constants' for the kind labels returned by the Ohana API.
var GENERIC = 'Generic';

function create(kind) {
  var marker = new Marker();
  if (kind) marker.setIcon(kind);
  return marker;
}

function Marker() {

  // The possible states of the icon.
  var SMALL_ICON = 1;
  var LARGE_ICON = 2;
  var SPIDERFIED_ICON = 4;
  var UNSPIDERFIED_ICON = 8;

  // A bitmask instance for tracking the four states of the icon appearance.
  var _iconState = BitMask.create();
  _iconState.turnOn(SMALL_ICON | UNSPIDERFIED_ICON);

  // The kind set on this marker.
  var _kind;

  var LARGE_MARKER_URL;
  var SMALL_MARKER_URL;
  var LARGE_SPIDERFY_MARKER_URL;
  var SMALL_SPIDERFY_MARKER_URL;

  function setIcon(kind) {
    _kind = kind;

    switch (kind) {
    case GENERIC :
      LARGE_MARKER_URL          = document.getElementById('generic-marker').dataset.url;
      SMALL_MARKER_URL          = document.getElementById('generic-marker').dataset.url;
      LARGE_SPIDERFY_MARKER_URL = document.getElementById('spider-marker').dataset.url;
      SMALL_SPIDERFY_MARKER_URL = document.getElementById('spider-marker').dataset.url;
      break;
    }
  }

  // @return [String] The URL for the marker. If the state isn't set the
  // icon defaults to the large, unspiderfied marker.
  function getIcon() {
    if (!_kind) setIcon(GENERIC);

    if (_iconState.isOn(SMALL_ICON) && _iconState.isOn(UNSPIDERFIED_ICON))
      return SMALL_MARKER_URL;
    else if (_iconState.isOn(SMALL_ICON) && _iconState.isOn(SPIDERFIED_ICON))
      return SMALL_SPIDERFY_MARKER_URL;
    else if (_iconState.isOn(LARGE_ICON) && _iconState.isOn(SPIDERFIED_ICON))
      return LARGE_SPIDERFY_MARKER_URL;
    else
      return LARGE_MARKER_URL;
  }

  // @param state [Number] Check whether the icon is large, small,
  // spiderfied, or not.
  function isOn(state) {
    return _iconState.isOn(state);
  }

  // @param state [Number] Check whether the icon is NOT large, small,
  // spiderfied, or not.
  function isOff(state) {
    return _iconState.isOff(state);
  }

  // @param state [Number] Set whether the icon is large, small,
  // spiderfied, or not.
  function turnOn(state) {
    _toggleState(state);
    _iconState.turnOn(state);
  }

  // @param state [Number] Set whether the icon is NOT large, small,
  // spiderfied, or not.
  function turnOff(state) {
    _toggleState(state);
    _iconState.turnOff(state);
  }

  // @param state [Number] If a particular state is turned on,
  // turn off the opposite.
  function _toggleState(state) {
    if (state & SMALL_ICON)         _iconState.turnOff(LARGE_ICON);
    if (state & LARGE_ICON)         _iconState.turnOff(SMALL_ICON);
    if (state & SPIDERFIED_ICON)    _iconState.turnOff(UNSPIDERFIED_ICON);
    if (state & UNSPIDERFIED_ICON)  _iconState.turnOff(SPIDERFIED_ICON);
  }

  return {
    setIcon:setIcon,
    getIcon:getIcon,
    isOn:isOn,
    isOff:isOff,
    turnOn:turnOn,
    turnOff:turnOff,
    SMALL_ICON:SMALL_ICON,
    LARGE_ICON:LARGE_ICON,
    SPIDERFIED_ICON:SPIDERFIED_ICON,
    UNSPIDERFIED_ICON:UNSPIDERFIED_ICON
  };
}

export default {
  create:create,
  GENERIC:GENERIC
};
