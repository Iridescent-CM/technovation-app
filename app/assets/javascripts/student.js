//= require application
//= require jquery-ui/widgets/accordion
//= require dropzone

//= require forms
//= require search
//= require toggling-select
//= require char-counter
//= require submissions
//= require dropzones
//= require code-checklists

document.addEventListener('turbolinks:load', function () {
  $(".accordion").accordion()
})