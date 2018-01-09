$(document).on("click", "#team_submissions__menu a", function(e) {
  e.preventDefault();

  var anchor = "#" + $(this).attr('href').split("#")[1],
      offset = 92;

  $(anchor)[0].scrollIntoView();
  location.href = anchor;

  scrollBy(0, -offset);
});

$(document).on("click", ".submission-pieces__screenshot", function(e) {
  swal({
    imageUrl: $(e.target).data("modalUrl"),
  });
});
