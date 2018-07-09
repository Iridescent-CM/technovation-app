$(document).on("turbolinks:load", function() {
  $('.tabs').not('.tabs--css-only').each(function() {
    var $links = $(this).find('.tab-menu, .tabs__menu')
                        .first()
                        .find('.tab-link, .tabs__menu-link'),

        $contents = $(this).find('.content, .tabs__content')
                           .first()
                           .find('> .tab-content, > .tabs__tab-content');

    // possible col--sticky
    if ($contents.length === 0)
      $contents = $(this).find('.content .col--sticky')
                         .first()
                         .find('> .tab-content');

    // possible tabs-vertical layout
    if ($contents.length === 0)
      $contents = $('#' + $(this).prop('id') + ' + .content .tab-content');

    $links.filter(":visible")
      .first()
      .addClass("tabs__menu-link--active");

    $contents.first()
      .removeClass("hidden");

    var intendedTab = (window.location.hash).replace(/#\/?!?/, '');

    if (intendedTab.length === 0)
      intendedTab = $links.filter(":visible").first()
        .find(".tab-button, .tabs__menu-button")
        .data("tab-id");

    $links.each(function() {
      var $btn = $(this).find('button').first();
      $btn.data('update-hash', true);

      $(this).on('click', function(e) {
        e.preventDefault();
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

  $(".content, .tabs__content").on("click", closeTabMenu);

  function closeTabMenu() {
    var $menu = $(this).closest(".tabs").find(".tab-menu, .tabs__menu");

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
    var $menu = $(this).closest(".tabs").find(".tab-menu, .tabs__menu");

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
    if (!$_btn.data('tab-id'))
      $_btn = $_btn.find('button').first();

    if ($_btn.data('update-hash')) {
      history.replaceState(history.state, "", "#!" + $_btn.data('tab-id'))
    }

    $_btn.data('update-hash', true);

    $_contents.addClass('hidden');
    $_links.removeClass('tabs__menu-link--active');

    $_btn.closest('.tab-link, .tabs__menu-link')
      .addClass('tabs__menu-link--active');

    var $revealEl = $('#' + $_btn.data('tab-id'));
    $revealEl.removeClass('hidden');

    var $parentTab = $_btn.closest('.tab-content, .tabs__tab-content');

    if ($parentTab.length !== 0) {
      var $parentBtn = $('[data-tab-id]').filter(function() {
        return $(this).data('tab-id') == $parentTab.prop('id');
      }).first();

      $parentBtn.removeData('update-hash');

      revealTab($parentBtn, $_contents, $_links);
    }

    var $links = $revealEl.find('.tab-menu, .tabs__menu')
                          .first()
                          .find('.tab-link, .tabs__menu-link'),
        $contents = $revealEl.find('.content, .tabs__content')
                             .first()
                             .find('> .tab-content, > .tabs__tab-content');

    // possible tabs-vertical layout
    if ($contents.length === 0)
      $contents = $(
        '#' +
        $revealEl.prop('id') +
        ' + .content .tab-content'
      );

    if ($contents.length === 0)
      $contents = $(
        '#' +
        $revealEl.prop('id') +
        ' + .tabs__content .tabs__tab-content'
      );

    $links.filter(":visible").first().addClass("tabs__menu-link--active");
    $contents.first().removeClass("hidden");
  }
});
