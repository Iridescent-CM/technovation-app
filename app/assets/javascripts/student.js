//= require application

//= require forms
//= require search

var offset = 92;

$(document).on("click", "#team_submissions--menu a", function(e) {
  e.preventDefault();
  var anchor = $(this).attr('href');
  $(anchor)[0].scrollIntoView();
  location.href = anchor;
  scrollBy(0, -offset);
});
