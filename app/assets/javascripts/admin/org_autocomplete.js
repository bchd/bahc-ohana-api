$(document).ready(function() {
  var selected = {
    name: $('#location_organization').attr('name'),
    id: $('#location_organization').attr('org_id')
  };

  $('#org-name').select2({
    minimumInputLength: 3,
    ajax: {
      url: $(this).data('url'),
      dataType: "json",
      data: function(term, page) {

        return {
          q: term,
        }
      },
      results: function(data, page) {

        return {
          results: $.map( data, function(org, i) {
            return { id: org[0], text: org[1] }
          } )
        }
      }
    }
  });

 $('.select2-chosen').text(selected['name']);
});
