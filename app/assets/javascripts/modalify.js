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
      hideModal(currentModal);
    });


    var modalShade = document.createElement('div');
    modalShade.classList.add('modalify__shade');

    modalBody.insertBefore(modalTopBar, modalBody.firstChild);
    currentModal.appendChild(modalBody);
    currentModal.insertBefore(modalShade, modalBody);

    modalShade.addEventListener('click', function() {
      hideModal(currentModal);
    });
  }

  var modalTriggers = document.querySelectorAll('[data-modal-trigger]');
  for (var i = 0; i < modalTriggers.length; i++) {
    var currentTrigger = modalTriggers[i];
    currentTrigger.addEventListener('click', function() {
      showModal(currentTrigger.dataset.modalTrigger);
    });
  }

  function hideModal(modal) {
    modal.classList.remove('modalify--active');
  }

  function showModal(modalId) {
    var modalToShow = document.getElementById(modalId);
    if (!modalToShow) {
      console.error('Could not find modal with id of ' + modalId);
      return;
    }
    modalToShow.classList.add('modalify--active');
  }
})();

