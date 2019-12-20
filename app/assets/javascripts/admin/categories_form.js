var main = (function () {
"use strict";

  var NUM_LEVELS = 2;

  // initalize the application
  function init()
  {
    var checkboxes = $('#categories input');

    var currentCheckbox;
    for (var i=0; i < checkboxes.length; i++)
    {
      currentCheckbox = checkboxes[i];
      _checkState('depth',0,currentCheckbox);
    }

    var curr;
    for (var l=0; l < checkboxes.length; l++)
    {
      curr = checkboxes[l];
      $(curr).click(_linkClickedHandler)
    }

    // Set event handler for expand/collapse all buttons
    $("#expand-categories-toggle").on("click", (e) => {
      _toggleExpanded(e)
    })

    // Make sure all parent checkboxes of the checked box are checked
    $(".checkbox").on("click", (e) => {
      var el = $(e.target)

      if (el.prop("checked") == true) {
        _checkParentStates(el)
      } else if (el.prop("checked") == false) {
        _uncheckChildStates(el)
      }
    })
  }

  function _linkClickedHandler(evt)
  {
    var el = evt.target;
    if (el.nodeName == 'INPUT')
    {
      _checkState('depth',0,el);
    }

  }

  function _checkState(prefix,depth,checkbox)
  {
    var item = $(checkbox).parent(); // parent li item
    var id = prefix+String(depth);
    while(!item.hasClass(id))
    {
      depth++;
      id = prefix+String(depth);
    }

    id = 'li.'+prefix+String(depth+1);
    var lnks = $(id,item);
    var curr;
    for (var l=0; l < lnks.length; l++)
    {
      curr = lnks[l];

      // Skips existing checkbox functionality if the categories are expanded
      if (!$("#categories").hasClass("expanded")) {
        if (checkbox.checked)
        {
          $(curr).removeClass('hide');
        }
        else
        {
          $(curr).addClass('hide');
          checkbox = $('input',$(curr))
          checkbox.prop('checked', false);
          _checkState(prefix,depth,checkbox)
        }
      }
    }
  }

  // Runs through all parents of a box that has been checked to make sure they are checked
  function _checkParentStates(el) {
    var parentCheckbox = el.parent().parents(".checkbox")
    parentCheckbox.children("input").prop("checked", true)

    if (el.parent().hasClass("depth0") || parentCheckbox.hasClass("depth0")) {
      return
    } else {
      _checkParentStates(parentCheckbox.children("input"))
    }
  }

  // Runs through all children checkboxes of a box that was unchecked to make sure they get unchecked
  function _uncheckChildStates(el) {
    el.prop("checked", false)
    var childrenCheckboxes = el.parent(".checkbox").children().find(".checkbox input").prop("checked", false)
  }

  // Toggles categories between being expanded and collapsed. Changes checkbox collapsing behavior depending on state
  function _toggleExpanded(e) {
    $("#categories").toggleClass("expanded")

    if ($("#categories").hasClass("expanded")) {
      $(e.target).text("Collapse All")
      $(".checkbox").removeClass("hide")
    } else {
      $(e.target).text("Expand All")
      $(".checkbox").not(".depth0").not((i, el) => {
        var checkbox_input = $(el).children("input")
        var sibling_checkboxes = $(el).parent().parent().children("ul li input")
        return checkbox_input.prop("checked") || sibling_checkboxes.prop("checked")
      }).addClass("hide")
    }
  }

  // return internally scoped var as value of globally scoped object
  return {
    init:init
  };

})();

$(document).ready(function(){
  main.init();
});
