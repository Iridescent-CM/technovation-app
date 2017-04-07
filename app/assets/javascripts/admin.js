//= require jquery2
//= require chosen-jquery
//= require lodash

//= require jquery_ujs
//= require clipboard

//= require utils
//= require admin/utils

//= require toast_flashes
//= require modalify
//= require tabs

//= require admin-results-tables
//= require admin-filter-options
//= require admin/pitch-events
//= require admin/buttonless-forms

(function enableAdminUI() {
  $('.chosen').chosen({
    width: '250px',
  });

  $('.chosen[data-reload]').chosen().change(function(e){
    Admin.Utils.updateURLSearchParams(e.target.name, e.target.value);
  });

  var clipboard = new Clipboard('.clipboard-btn');

  clipboard.on('success', function(e) {
    createFlashNotification('success', 'Special link copied! ');
  });

  clipboard.on('error', function(e) {
    createFlashNotification('error', 'Error: Highlight and use Ctrl/Cmd+C instead');
  });
})();
