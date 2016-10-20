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
  });
})();
