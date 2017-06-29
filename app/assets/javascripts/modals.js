const Modal = {
  open: function($_modal_or_modal_id) {
    var $_modal;

    if ($_modal_or_modal_id instanceof jQuery) {
      $_modal = $_modal_or_modal_id;
    } else {
      $_modal = $("#" + $_modal_or_modal_id);
    }

    $('#modal-shade').fadeIn();
    $_modal.fadeIn();
  },

  close: function($_modal) {
    $_modal.fadeOut(function() {
      const onCloseUrl = $(this).data('on-close');

      if (onCloseUrl)
        $.post(onCloseUrl);
    });

    $('#modal-shade').fadeOut();
  },
};

document.addEventListener("turbolinks:load", function() {
  $('[data-opens-modal]').on('click', function(e) {
    e.preventDefault();
    Modal.open($(this).data('opens-modal'));
  });

  $('.modal').each(function() {
    var $modal = $(this);

    attachHeading($modal);
    attachShade($modal);

    triggerPageLoadModals($modal);

    function attachHeading($_modal) {
      var $heading = $('<div>');

      $heading.addClass('modal-heading');
      $heading.text($_modal.data("heading"));

      $_modal.prepend($heading);
      attachCloseButton($_modal);
    }

    function attachCloseButton($_modal) {
      var $closeBtn = $('<span>');

      $closeBtn.addClass("icon-close");
      $closeBtn.on('click', function() { Modal.close($_modal) });

      $_modal.find(".modal-heading").append($closeBtn);
    }

    function attachShade($_modal) {
      $('#modal-shade').on('click', function() {
        Modal.close($_modal);
      });
    }

    function triggerPageLoadModals($_modal) {
      if ($_modal.data('open-on-page-load'))
        Modal.open($_modal);
    }
  });
});
