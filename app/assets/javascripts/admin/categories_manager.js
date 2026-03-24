$(document).on('turbolinks:load', function() {
  $('#categories-list').find('.category_list_element_name_container').click(function(e) {
      console.log(e.target)
    });  
});