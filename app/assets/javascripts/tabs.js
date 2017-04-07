//=require utils

(function tabs() {
  var tabs = document.querySelectorAll('.tabs');

  if (tabs.length === 0)
    return;

  var tabMenus = document.querySelectorAll('.tab-menu');
  forEach(tabMenus, function(tabMenu) {
    var firstItem = tabMenu.querySelector('.tab-link:first-child');
    firstItem.classList.add('active');
  });

  var contents = document.querySelectorAll('.content .tab-content');
  forEach(contents, function(content) {
    content.classList.add('tab-content__hiding');
  });

  contents[0].classList.remove('tab-content__hiding');
  contents[0].classList.add('tab-content__showing');

  forEach(tabs, function(tab) {
    var tabLinks = tab.querySelectorAll('.tab-link'),
        tabContents = tab.querySelectorAll('.tab-content');

    forEach(tabLinks, function(tabLink) {
      tabLink.addEventListener('click', revealTabContent, false);
      var btn = tabLink.querySelector('button'),
          intendedTab = (window.location.hash).replace('#', '');
      if (btn && intendedTab === btn.dataset.tabId)
        btn.click();
    });

    function revealTabContent(e) {
      e.preventDefault();
      var target = e.target;

      if (!target.dataset.tabId)
        target = e.target.querySelector('button');

      window.location.hash = "#" + target.dataset.tabId;

      forEach(tabContents, function(tabContent) {
        tabContent.classList.remove('tab-content__showing');
        tabContent.classList.add('tab-content__hiding');
      });

      forEach(tabLinks, function(tabLink) {
        tabLink.classList.remove('active');
      });

      target.parentElement.classList.add('active');

      var revealEl = document.getElementById(target.dataset.tabId);
      revealEl.classList.remove('tab-content__hiding');
      revealEl.classList.add('tab-content__showing');
    }
  });
})();
