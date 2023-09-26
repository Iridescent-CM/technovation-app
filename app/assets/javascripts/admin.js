// ******** POLYFILLS
//= require ie11-polyfills

// ******** VENDOR
//
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require chosen-jquery
//= require sweetalert2
//= require jquery.sticky-kit.min
//= require jquery.double-scroll
//= require ready

// ******** APP
//
//= require rails-ujs-overrides
//= require chosen-init
//= require flash-msgs
//= require tabs
//= require image-uploaders
//= require modals
//= require forms
//= require saved-searches
//= require jobs
//= require sticky-cols

document.addEventListener("turbolinks:load", function () {
  $(".accordion-toggle").on("click", function (e) {
    e.preventDefault();

    $accordion = $($(this).data("accordion"));

    $accordion.addClass("open");

    $(this).hide().next(".accordion-open").show();
  });

  $(document).on("change", "[data-remote-select]", function (evt) {
    var $el = $(this),
      data = {};

    data[$el.data("modelName")] = {};
    data[$el.data("modelName")][$el.data("fieldName")] = evt.target.value;

    $.ajax({
      method: "POST",
      url: $el.data("url"),
      data: data,
    });
  });

  // Scrollable datagrid table dual scrollbars
  $(".table--scrollable").doubleScroll({
    resetOnWindowResize: true,
  });

  // app/views/admin/team_submissions/edit.html.erb
  const checkboxes = document.querySelectorAll(
    ".submission-pieces__screenshots input[type='checkbox']"
  );

  checkboxes.forEach((checkbox) => {
    checkbox.addEventListener("click", () => {
      const screenshot = checkbox.parentNode.querySelector("img");
      if (screenshot) {
        checkbox.checked
          ? (screenshot.style.opacity = "0.5")
          : (screenshot.style.opacity = "1");
      }
    });
  });

  const invitationProfileType = document.getElementById("user_invitation_profile_type");

  if (invitationProfileType) {
    invitationProfileType.addEventListener("change", () => {
      const registerAtAnyTime = document.getElementById("user_invitation_register_at_any_time");

      if (invitationProfileType.value == "chapter_ambassador") {
        registerAtAnyTime.checked = true;
        registerAtAnyTime.disabled = true;
      }
      else {
        registerAtAnyTime.checked = false;
        registerAtAnyTime.disabled = false;
      }
    });
  }
});

$(document).ajaxSend(function (_, xhr) {
  xhr.setRequestHeader(
    "X-CSRF-Token",
    $('meta[name="csrf-token"]').attr("content")
  );
});
