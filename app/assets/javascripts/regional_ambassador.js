//= require application

document.addEventListener("turbolinks:load", function() {
  $("select.enum_filter").chosen({
    allow_single_deselect: true,
  });
});
