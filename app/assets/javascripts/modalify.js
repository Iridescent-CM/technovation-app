// Wrap your modal content with a div of class "modalyify" and a unique id
// Add optional data-heading attribute to wrapper to specify heading
// Add a button to your page with data-modal-trigger that matches the id
// <button
//   type="button"
//   data-modal-trigger="some-id-here"
// >
//   Open Modal
// </button>
//
// <div
//   class="modalify"
//   data-heading="Some cool title"
//   id="some-id-here"
// >
//   Wow, I am in a modal. Fancy that.
// </div>

(function modalify() {
  var modals = document.getElementsByClassName('modalify');

  for (var i = 0; i < modals.length; i++) {
    if (modals[i].classList.contains("modalify-one-time")) {
      return;
    }

    var currentModal = modals[i];
    var modalContent = currentModal.innerHTML;

    currentModal.innerHTML = '';

    var modalBody = document.createElement('div');
    modalBody.classList.add('modalify__body', 'simple-card');
    modalBody.innerHTML = modalContent;

    var modalTopBar = document.createElement('div');
    modalTopBar.classList.add('modalify__top-bar')

    if (currentModal.dataset.heading) {
      var modalHeading = document.createElement('h2');
      modalHeading.innerHTML = currentModal.dataset.heading;
      modalHeading.classList.add('modalify__heading');
      modalTopBar.appendChild(modalHeading);
    }

    var closeButton = document.createElement('span');
    closeButton.classList.add('fa', 'fa-times', 'modalify__close');
    modalTopBar.appendChild(closeButton);

    var modalShade = document.createElement('div');
    modalShade.classList.add('modalify__shade');

    modalBody.insertBefore(modalTopBar, modalBody.firstChild);
    currentModal.appendChild(modalBody);
    currentModal.insertBefore(modalShade, modalBody);

    modalShade.addEventListener('click', function() {
      hideModal(this);
    }.bind(currentModal));

    var closeBtns = currentModal.querySelectorAll('.modalify__close');
    forEach(closeBtns, function(closeBtn) {
      closeBtn.addEventListener('click', function(e) {
        e.preventDefault();
        hideModal(this);
      }.bind(currentModal));
    });

    if (currentModal.classList.contains('modalify-on-page-load'))
      showModal(null, currentModal.id);
  }

  var modalTriggers = document.querySelectorAll('[data-modal-trigger]');
  for (var i = 0; i < modalTriggers.length; i++) {
    var currentTrigger = modalTriggers[i];
    currentTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      showModal(e);
    });
  }

  function hideModal(modal) {
    modal.classList.remove('modalify--active');
    fixColumnZIndex(modal, 0);
    fireModalCloseEvent(modal);
    document.body.removeAttribute('style');
  }

  function showModal(e, modalId) {
    modalId = modalId || e.target.dataset.modalTrigger;
    var modalToShow = document.getElementById(modalId);
    if (!modalToShow) {
      console.error('Could not find modal with id of ' + modalId);
      return;
    }
    modalToShow.classList.add('modalify--active');
    fixColumnZIndex(modalToShow, 1);
    document.body.style.overflow = 'hidden';
  }

  function fireModalCloseEvent(modal) {
    var event = new CustomEvent('modalclose', {bubbles: true, cancelable: true});
    modal.dispatchEvent(event);
  }

  function fixColumnZIndex(modal, zidx) {
    var parentCol = modal.parentElement;
    var colFound = parentCol.classList.contains('submissions-col');

    while(!colFound) {
      parentCol = parentCol.parentElement;

      if (parentCol === null) {
        break;
      }

      colFound = parentCol.classList.contains('submissions-col');
    }

    if (colFound) {
      parentCol.style.zIndex = zidx;
    }
  }
})();
