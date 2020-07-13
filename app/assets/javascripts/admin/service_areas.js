$(document).ready(function() {
  $('#service_service_areas').select2();

  $(".select-all-archive").change(function(){
    $(".select-archive").prop('checked', $(this).is(":checked"))
  })
});
