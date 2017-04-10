//=require utils

(function tabs() {
  var tabs = document.querySelectorAll('.tabs');

  if (tabs.length === 0)
    return;

  revealFirstTabs();

  _.each(tabs, function(tabEl) {
    var tabSet = {
      el: tabEl,

      links: document.querySelectorAll('#' + tabEl.id + ' > .tab-menu .tab-link'),

      contents: document.querySelectorAll('#' + tabEl.id + ' > .content > .tab-content'),

      revealTab: function (e) {
        e.preventDefault();
        var target = e.target;

        if (!target.dataset.tabId)
          target = e.target.querySelector('button');

        if (target.dataset.updateHash === "true")
          window.location.hash = "#" + target.dataset.tabId;

        target.dataset.updateHash = true;

        _.each(this.contents, function(content) {
          content.classList.remove('tab-content__showing');
          content.classList.add('tab-content__hiding');
        });

        _.each(this.links, function(link) {
          link.classList.remove('active');
        });

        target.parentElement.classList.add('active');

        var revealEl = document.getElementById(target.dataset.tabId);
        revealEl.classList.remove('tab-content__hiding');
        revealEl.classList.add('tab-content__showing');

        var parentTab = closest(this.el, '.tab-content');

        if (parentTab) {
          var btn = document.querySelector('button[data-tab-id="' + parentTab.id + '"]');
          btn.dataset.updateHash = false;
          btn.click();
        }
      },
    };

    // possible tabs-vertical layout
    if (tabSet.contents.length === 0)
      tabSet.contents = document.querySelectorAll(
        '#' + tabSet.el.id + ' + .content .tab-content'
      );

    _.each(tabSet.links, function(link) {
      var btn = link.querySelector('button');
      btn.dataset.updateHash = true;

      link.addEventListener('click', tabSet.revealTab.bind(tabSet), false);

      var intendedTab = (window.location.hash).replace('#', '');

      if (btn && intendedTab === btn.dataset.tabId)
        btn.click();
    });
  });

  function revealFirstTabs() {
    var tabMenus = document.querySelectorAll('.tab-menu');

    _.each(tabMenus, function(tabMenu) {
      var firstItem = tabMenu.querySelector('.tab-link:first-child');
      firstItem.classList.add('active');
    });

    var tabContents = document.querySelectorAll('.tab-content');

    _.each(tabContents, function(content) {
      content.classList.add('tab-content__hiding');
    });

    var contents = document.querySelectorAll('.content');

    _.each(contents, function(content) {
      var firstItem = content.querySelector('.tab-content');
      firstItem.classList.remove('tab-content__hiding');
      firstItem.classList.add('tab-content__showing');
    });
  }
})();
