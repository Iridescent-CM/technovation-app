//= require application
//= require jquery.sticky-kit.min

//= require forms
//= require search

document.addEventListener("turbolinks:load", function() {
  $(".col--sticky").stick_in_parent();
});
