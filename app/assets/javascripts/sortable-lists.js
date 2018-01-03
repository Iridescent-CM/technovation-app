$(document).on("ready turbolinks:load", function() {
  var container = document.getElementById("sortable-list");

  var drake = dragula([container], {
    isContainer: function (el) {
      return el.classList.contains(".sortable-list");
    },
    moves: function (el, source, handle, sibling) {
      return handle.classList.contains("sortable-list__drag-handle");
    },
    accepts: function (el, target, source, sibling) {
      return true;
    },
    invalid: function (el, handle) {
      return false;
    },
    direction: 'vertical',
    copy: false,
    copySortSource: false,
    revertOnSpill: false,
    removeOnSpill: false,
    mirrorContainer: document.body,
    ignoreInputTextSelection: true,
  });

  drake.on("drop", function (el, target, source, sibling) {
    var url = $(target).data("sortUrl"),
        items = $(target).find(".sortable-list__item"),
        data = {
          team_submission: {
            screenshots: items.map(function(i, el) {
              return $(el).data("dbId");
            }).toArray(),
          },
        };

    $.ajax({
      method: "PATCH",
      url: url,
      data: data,
      success: function() {
        if (window.timeout) {
          clearTimeout(window.timeout);
          window.timeout = null;
        }

        $(el).addClass("sortable-list--updated");

        window.timeout = setTimeout(function () {
          $(el).removeClass("sortable-list--updated");
        }, 100);
      },
    });
  });
});
