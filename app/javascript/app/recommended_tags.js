$("#keyword").on("focus", () => {
  $("#recommended-tags").removeClass("hide");
});

$(document).on("click", (e) => {
  if (e.target.id == "keyword") { return; }
  if (e.target.id == "recommended-tags") { return; }

  if (e.target.parentNode.id == "recommended-tags") { return; }

  $("#recommended-tags").addClass("hide");
});

$(".recommended-tag").on("click", (e) => {
  e.preventDefault();
  let target = e.target;
  $("#keyword").val(target.dataset.tags);
  $("#form-search").submit();
});
