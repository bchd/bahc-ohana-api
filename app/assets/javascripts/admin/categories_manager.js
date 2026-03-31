$(document).on('turbolinks:load', function() {
  $('#categories-list').find('.category_list_element_name_container').click(function(e) {
      toggle_subcategory_visibility_by_category(e.currentTarget);
    });  

  $("#categories-list").find('.category_list_element_name_container').on("keydown", function(e) {
    if (e.which === 13) {
      toggle_subcategory_visibility_by_category(e.currentTarget);
      e.preventDefault(); 
      }
    });  

  $('#expand_all').click(function(e) {
      toggle_global_subcategory_visibility(e.currentTarget);
    });    

  function toggle_subcategory_visibility_by_category(element) {
    let subcategories = $(`#${element.id}_subcategories`)
    let chevron = $(element).children('.fa')
    subcategories.toggleClass('hide');
    if (element.ariaExpanded === "true") {
      element.ariaExpanded = "false";
      chevron.addClass('fa-chevron-right').removeClass('fa-chevron-down');
    } else {
      element.ariaExpanded = "true";
      chevron.addClass('fa-chevron-down').removeClass('fa-chevron-right');
    }
  };  

  function toggle_global_subcategory_visibility(element) {
    let all_chevrons = $('#categories-list').find('.category_list_element_name_container .fa');
    let all_subcategories = $('#categories-list').find('.subcategories_container');

    if (element.ariaExpanded === "true") {
      element.innerText = "Expand all";
      element.ariaExpanded = "false";
      all_chevrons.addClass('fa-chevron-right').removeClass('fa-chevron-down');
      all_subcategories.addClass('hide');
    } else {
      element.innerText = "Collapse all";
      element.ariaExpanded = "true";
      all_chevrons.addClass('fa-chevron-down').removeClass('fa-chevron-right');
      all_subcategories.removeClass('hide');
    }
  };  
});