(function globalNav() {
  var mobileToggle = document.getElementById('mobile-menu-toggle');
  if (!mobileToggle) {
    return;
  }

  mobileToggle.addEventListener('click', toggleMobileMenu);

  var navLinksList = document.querySelector('.navigation__links-list');
  var body = document.querySelector('body');

  // On first click, show
  var shouldShow = true;
  function toggleMobileMenu(e) {
    e.preventDefault();
    if (shouldShow) {
      body.style.overflow = 'hidden';
      navLinksList.classList.add('navigation__links-list--show');
      mobileToggle.classList.remove('fa-bars');
      mobileToggle.classList.add('fa-times');
    } else {
      body.style.overflow = '';
      navLinksList.classList.remove('navigation__links-list--show');
      mobileToggle.classList.remove('fa-times');
      mobileToggle.classList.add('fa-bars');
    }

    shouldShow = !shouldShow;
  }
})();
