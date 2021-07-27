$(document).on("DOMContentLoaded", function() {
  $('.tabs').not('.tabs--css-only').each(function() {
    var $links = $(this).find('.tabs__menu')
                        .first()
                        .find('.tabs__menu-link'),

        $contents = $(this).find('.tabs__content')
                           .first()
                           .find('> .tabs__tab-content');

    // possible col--sticky
    if ($contents.length === 0)
      $contents = $(this).find('.tabs__content .col--sticky')
                         .first()
                         .find('> .tabs__tab-content');

    // Possible tabs--vertical layout
    if ($contents.length === 0)
      $contents = $('#' + $(this).prop('id') + ' + .tabs__content .tabs__tab-content');

    $links.filter(":visible")
      .first()
      .addClass("tabs__menu-link--active");

    $contents.first()
      .removeClass("hidden");

    var intendedTab = (window.location.hash).replace(/#\/?!?/, '');

    if (intendedTab.length === 0)
      intendedTab = $links.filter(":visible").first()
        .find(".tabs__menu-button")
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

  function revealTab($_btn, $_contents, $_links) {
    if (!$_btn.data('tab-id'))
      $_btn = $_btn.find('button').first();

    if ($_btn.data('update-hash')) {
      history.replaceState(history.state, "", "#!" + $_btn.data('tab-id'))
    }

    $_btn.data('update-hash', true);

    $_contents.addClass('hidden');
    $_links.removeClass('tabs__menu-link--active');

    $_btn.closest('.tabs__menu-link')
      .addClass('tabs__menu-link--active');

    var $revealEl = $('#' + $_btn.data('tab-id'));
    $revealEl.removeClass('hidden');

    var $parentTab = $_btn.closest('.tabs__tab-content');

    if ($parentTab.length !== 0) {
      var $parentBtn = $('[data-tab-id]').filter(function() {
        return $(this).data('tab-id') == $parentTab.prop('id');
      }).first();

      $parentBtn.removeData('update-hash');

      revealTab($parentBtn, $_contents, $_links);
    }

    var $links = $revealEl.find('.tabs__menu')
                          .first()
                          .find('.tabs__menu-link'),
        $contents = $revealEl.find('.tabs__content')
                             .first()
                             .find('> .tabs__tab-content');

    // Possible tabs--vertical layout
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
