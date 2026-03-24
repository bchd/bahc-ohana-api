$(document).on('turbolinks:load', function() {
  $('#categories-list').find('.category_list_element_name_container').click(function(e) {
      toggle_subcategory_visibility(e.currentTarget);
    });  

  $("#categories-list").find('.category_list_element_name_container').on("keydown", function(e) {
    if (e.which === 13) {
      toggle_subcategory_visibility(e.currentTarget);
      e.preventDefault(); 
      }
    });  

  function toggle_subcategory_visibility(element) {
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
});