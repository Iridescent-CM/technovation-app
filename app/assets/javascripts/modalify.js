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
    closeButton.addEventListener('click', function() {
      hideModal(this);
      cancelFileUploads(this);
    }.bind(currentModal));


    var modalShade = document.createElement('div');
    modalShade.classList.add('modalify__shade');

    modalBody.insertBefore(modalTopBar, modalBody.firstChild);
    currentModal.appendChild(modalBody);
    currentModal.insertBefore(modalShade, modalBody);

    modalShade.addEventListener('click', function() {
      hideModal(this);
      cancelFileUploads(this);
    }.bind(currentModal));
  }

  var modalTriggers = document.querySelectorAll('[data-modal-trigger]');
  for (var i = 0; i < modalTriggers.length; i++) {
    var currentTrigger = modalTriggers[i];
    currentTrigger.addEventListener('click', function(e) {
      showModal(e);
    });
  }

  function hideModal(modal) {
    modal.classList.remove('modalify--active');
  }

  function showModal(e) {
    var modalId = e.target.dataset.modalTrigger;
    var modalToShow = document.getElementById(modalId);
    if (!modalToShow) {
      console.error('Could not find modal with id of ' + modalId);
      return;
    }
    modalToShow.classList.add('modalify--active');
  }

  function cancelFileUploads(modal) {
    var inputs = modal.getElementsByTagName('input');
    for (var i = 0; i < inputs.length; i++) {
      if (inputs[i].type === 'file') {
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent("change", false, true);
        inputs[i].value = null;
        inputs[i].dispatchEvent(evt);
      }
    }
  }
})();

