$(document).on('turbolinks:load', function() {
  $('#org-name').select2({
    minimumInputLength: 3,
    placeholder: $(this).data('paceholder'),
    ajax: {
      url: $(this).data('url'),
      dataType: "json",
      data: function(params) {

        return {
          q: { keyword: params.term }
        }
      },
      processResults: function(data) {
        return {
          results: $.map( data, function(org, i) {
            return { id: org[0], text: org[1] }
          } )
        }
      }
    }
  });
});
