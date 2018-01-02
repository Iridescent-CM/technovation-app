$(document).on("ready turbolinks:load", function() {
  var container = document.getElementById("sortable-list");

  dragula([container], {
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
});
