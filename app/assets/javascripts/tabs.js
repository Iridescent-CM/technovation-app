// TODO: broken on mentor dashboard
document.addEventListener("turbolinks:load", function() {
  $('.tabs').each(function() {
    var $links = $(this).find('.tab-menu').first().find('.tab-link'),
        $contents = $(this).find('.content').first().find('> .tab-content');

    // possible tabs-vertical layout
    if ($contents.length === 0)
      $contents = $('#' + $(this).prop('id') + ' + .content .tab-content');

    $links.filter(":visible").first().addClass("active");
    $contents.first().removeClass("hidden");

    var intendedTab = (window.location.hash).replace(/#!?/, '');
    if (intendedTab.length === 0)
      intendedTab = $links.filter(":visible").first()
        .find(".tab-button")
        .data("tab-id");

    $links.each(function() {
      var $btn = $(this).find('button').first();
      $btn.data('update-hash', true);

      $(this).on('click', function() {
        revealTab($(this), $contents, $links);
      });

      if ($btn && intendedTab === $btn.data('tab-id'))
        revealTab($btn, $contents, $links);
    });
  });

  $(".close-tab-menu").on("click", function() {
    $(this).hide();
    closeTabMenu.bind(this)();
  });

  $(".open-tab-menu").on("click", function() {
    $(this).hide();
    openTabMenu.bind(this)();
  });

  $(".content").on("click", closeTabMenu);

  function closeTabMenu() {
    var $menu = $(this).closest(".tabs").find(".tab-menu");

    if ($menu.data("open")) {
      $menu
        .data("closed", true)
        .removeData("open")
        .css({ left: "-100%" })
        .closest(".tabs")
        .find(".open-tab-menu")
        .show();
    }
  }

  function openTabMenu() {
    var $menu = $(this).closest(".tabs").find(".tab-menu");

    if ($menu.data("closed")) {
      $menu
        .data("open", true)
        .removeData("closed")
        .css({ left: 0 })
        .closest(".tabs")
        .find(".close-tab-menu")
        .show();
    }
  }

  function revealTab($_btn, $_contents, $_links) {
    console.log($_contents);
    if (!$_btn.data('tab-id'))
      $_btn = $_btn.find('button').first();

    if ($_btn.data('update-hash'))
      window.location.hash = "#!" + $_btn.data('tab-id');

    $_btn.data('update-hash', true);

    $_contents.addClass('hidden');
    $_links.removeClass('active');

    $_btn.closest('.tab-link').addClass('active');

    var $revealEl = $('#' + $_btn.data('tab-id'));
    $revealEl.removeClass('hidden');

    var $parentTab = $_btn.closest('.tab-content');

    if ($parentTab.length !== 0) {
      var $parentBtn = $('[data-tab-id]').filter(function() {
        return $(this).data('tab-id') == $parentTab.prop('id');
      }).first();

      $parentBtn.removeData('update-hash');

      revealTab($parentBtn, $_contents, $_links);
    }

    var $links = $revealEl.find('.tab-menu').first().find('.tab-link'),
        $contents = $revealEl.find('.content').first().find('> .tab-content');

    // possible tabs-vertical layout
    if ($contents.length === 0)
      $contents = $('#' + $revealEl.prop('id') + ' + .content .tab-content');

    $links.filter(":visible").first().addClass("active");
    $contents.first().removeClass("hidden");
  }
});
