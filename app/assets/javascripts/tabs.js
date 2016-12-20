(function tabs() {
  var tabs = document.querySelectorAll('.tabs');
  if (tabs.length === 0) {
    return;
  }

  for (var i = 0; i < tabs.length; i++) {
    (function() {
      var tabLinks = tabs[i].querySelectorAll('.tab-link'),
          tabContents = tabs[i].querySelectorAll('.tab-content');

      for (var j = 0; j < tabLinks.length; j ++) {
        tabLinks[j].addEventListener('click', revealTabContent, false);
      }

      function revealTabContent(e) {
        e.preventDefault();

        for (var k = 0; k < tabContents.length; k++) {
          tabContents[k].classList.remove('tab-content__showing');
          tabContents[k].classList.add('tab-content__hiding');
        }

        for (var l = 0; l < tabLinks.length; l++) {
          tabLinks[l].classList.remove('active');
        }

        e.target.parentElement.classList.add('active');

        var revealEl = document.getElementById(e.target.dataset.tabId);
        revealEl.classList.remove('tab-content__hiding');
        revealEl.classList.add('tab-content__showing');
      }
    })();
  }
})();
