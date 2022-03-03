const ReportForm = (function() {
  const init = function() {
    const $allCheckboxes = $(".flag-form input[type='checkbox']");

    $allCheckboxes.val('false');

    $allCheckboxes.on('click', function() {
      const $this = $(this);
      const textFieldTargetID = $(this).data('target-id');
      const $inputElement = $(`.js-input-field:input[id='${textFieldTargetID}']`);

      if ($this.is(':checked')) {
        $this.val('true');
        $inputElement.removeClass('hidden');
      } else {
        $this.val('false');
        $inputElement.addClass('hidden');
      }
    });
  };

  return { init: init };
}());

// jQuery
$(document).ready(function () {
  ReportForm.init();
});
