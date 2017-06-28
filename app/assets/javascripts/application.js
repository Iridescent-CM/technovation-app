//= require jquery2
//= require jquery_ujs
//= require foundation
//= require jquery-ui/effect.all
//= require lodash
//= require chosen-jquery
//= require country_state_select
//= require sortable
//= require jquery.query
//= require facebook_sdk
//= require jquery.sticky-kit.1.1.2.min
//= require dragula
//= require closest-polyfill
//= require event-polyfill
//= require prepend-polyfill
//= require rangeslider

//= require utils
//= require ajax_form_handler
//= require background_checks
//= require fancy_file_upload
//= require fancy_image_upload
//= require fancy_input
//= require fancy_select
//= require fancy_uploads
//= require gallerify
//= require global_nav
//= require homepage/homepage
//= require judging_form
//= require modalify
//= require remote_forms
//= require search_options
//= require select_fields
//= require submission_edit_screenshots
//= require submissions_onboarding
//= require submissions_page
//= require technical_checklist
//= require toast_flashes
//= require tabs
//= require alternative_forms
//= require multiple_image_upload
//= require account_geolocation

//= require submission_scores
//= require dashboards
//= require select-pitch-events

(function() {
  $(".chosen").chosen({
    placeholder_text_single: "Choose a country",
  });
})();

$(function(){ $(document).foundation(); });
