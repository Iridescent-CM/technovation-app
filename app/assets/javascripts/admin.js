//= require jquery2
//= require chosen-jquery

//= require vanilla-ujs
//= require clipboard

//= require utils
//= require admin/utils

//= require toast_flashes

//= require admin-results-tables
//= require admin-filter-options
//= require admin/pitch-events
//= require admin/buttonless-forms

(function enableAdminUI() {
  $('.chosen').chosen({
    width: '250px',
  });

  var clipboard = new Clipboard('.clipboard-btn');

  clipboard.on('success', function(e) {
    createFlashNotification('success', 'Special link copied! ');
  });

  clipboard.on('error', function(e) {
    createFlashNotification('error', 'Error: Highlight and use Ctrl/Cmd+C instead');
  });
})();
