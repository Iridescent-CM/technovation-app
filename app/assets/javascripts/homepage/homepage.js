/*
 * Show-hide the welcome message on home page
 * @todo: Break this out into a generic function if this is functionality we'd like to replicate
 */

(function homepageMessageToggle() {
  var toggleButton = document.querySelector('.home-page__expand-welcome-message');
  var welcomeMessageArea = document.querySelector('.home-page__welcome-message');
  if (!toggleButton || !welcomeMessageArea) {
    return;
  }

  toggleButton.addEventListener('click', function() {
    welcomeMessageArea.classList.toggle('home-page__welcome-message--open');
    toggleMessageHeight();
  });

  var isOpen = false;
  var messageOverflowContainer = document.querySelector('.home-page__welcome-message-overflow-container');
  var messageWrapper = messageOverflowContainer.querySelector('.home-page__welcome-message-wrapper');
  function toggleMessageHeight() {
    if (!isOpen) {
      messageOverflowContainer.style.height = messageWrapper.clientHeight + 'px';
    } else {
      messageOverflowContainer.style.height = 0;
    }
    isOpen = !isOpen;
  }
})();
