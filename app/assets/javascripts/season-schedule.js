document.addEventListener("turbolinks:load", function() {
  const $judgingRoundChoices = $('[name="season_toggles[judging_round]"]'),
        $scheduleForm = $('#season_schedule');

  if ($judgingRoundChoices.length === 0) {
    return;
  } else {
    handleJudgingRoundChanges($judgingRoundChoices);
    handleSeasonSettingsReview($scheduleForm);
  }

  function handleJudgingRoundChanges($choices) {
    const $container = $choices.closest('.tabs__tab-content'),

          $blockedByJudging = $('[data-blocked-by-judging=true]'),
          originalTextColor = $blockedByJudging.css('color'),

          store = localStorage,

          validChoices = {
            off: "off",
            qf: "qf",
            sf: "sf",
          },

          selectedChoiceOnLoad = $choices.filter(function() {
            return $(this).prop('checked');
          })[0];

    // see comments in storeOriginalValuesLocally();
    var lastChoiceMade = selectedChoiceOnLoad.value;

    if (selectedChoiceOnLoad.value !== validChoices.off) {
      handleJudgingEnabled();
    }

    $choices.on('change', function(e) {
      const choice = e.target.value;

      if (choice !== validChoices.off) {
        handleJudgingEnabled();
      } else {
        handleJudgingDisabled();
      }

      // see comments in storeOriginalValuesLocally();
      lastChoiceMade = choice;
    });

    $(window).on("unload", function() {
      clearLocalStorage();
    });

    function handleJudgingEnabled() {
      disableSettingsBlockedByJudging();
      storeOriginalValuesLocally();
      notifyUserOfEffect();
      $blockedByJudging.prop('checked', false);

      function disableSettingsBlockedByJudging() {
        $blockedByJudging.prop('disabled', true);

        $blockedByJudging.next('label').css({
          color: 'lightgrey',
          fontStyle: 'italic',
          fontSize: '0.9rem',
          cursor: 'not-allowed',
        });
      }

      function storeOriginalValuesLocally() {
        if (lastChoiceMade === validChoices.off) {
          $blockedByJudging.each(function() {
            const choiceElemId = $(this).prop('id'),
                  isChecked = $(this).prop('checked');

            store[choiceElemId] = isChecked;
          });
        } // else
        // judging had been on, meaning all the settings were set to false
        // and we don't want to store that state
      }

      function notifyUserOfEffect() {
        if ($container.find('.notice').length === 0) {
          var $notice = $('<div>');

          $notice.addClass('notice info hint');
          $notice.html("<span class='fa fa-exclamation-circle'></span> Enabling judging has affected other season features.");

          $container.append($notice);
        }

        notifyUserOnEachInputDisabledByJudging()
      }

      function notifyUserOnEachInputDisabledByJudging() {
        $('[data-blocked-by-judging=true][disabled]')
          .not('.user-notified')
          .each(function() {

          const $tab = $(this).closest('.tabs__tab-content');

          var $notice = $('<div>');

          $notice.addClass('notice info hint user-notice');
          $notice.html(
            "<span class='fa fa-exclamation-circle'></span> " +
            "When judging is enabled, " +
            $(this).data('when-blocked')
          );

          $(this).next('label').after($notice);

          const $menuItem = $('.tabs__menu').find(
            '[data-tab-id=' + $tab.prop('id') + ']'
          );

          $menuItem.addClass('contains-disabled-items');

          $(this).addClass('user-notified');
        });
      }
    }

    function handleJudgingDisabled() {
      removeUserNotices();
      enableSettingsBlockedByJudging();
      restoreOriginalValues();
      clearLocalStorage();

      function removeUserNotices() {
        $container.find('.notice').remove();
        $('.contains-disabled-items').removeClass('contains-disabled-items');
        $('.user-notice').remove();
        $('.user-notified').removeClass('user-notified')
      }

      function enableSettingsBlockedByJudging() {
        $blockedByJudging.removeAttr('disabled');

        $blockedByJudging.next('label').css({
          color: originalTextColor,
          fontStyle: 'normal',
          fontSize: '1rem',
          cursor: 'pointer',
        });
      }

      function restoreOriginalValues() {
        $blockedByJudging.each(function() {
          const originalVal = store[$(this).prop('id')];
          $(this).prop('checked', originalVal === "true");
        });
      }
    }

    function clearLocalStorage() {
      $blockedByJudging.each(function() {
        store.removeItem($(this).prop('id'));
      });
    }
  }

  function handleSeasonSettingsReview($form) {
    const $reviewDiv = $('#season_review');

    $(document).on('click', '#season_schedule [data-prepares-modal]', function (e) {
      e.preventDefault()

      if (!$(e.target).data("preparesModal"))
        return false

      $(document).on("click", '[data-submit-form]', function () {
        $form.submit()
      })

      var $modal = $('#' + $(e.target).data("preparesModal"))

      $reviewDiv.html("")

      new Promise(function(resolve, reject) {
        $('h4').each(function() {
          var $panel = appendPanel($(this), $reviewDiv);

          appendLabels(
            $panel,
            $(this).closest('.tabs__tab-content').find('label')
          );
        })

        resolve()
      }).then(function() {
        swal({
          html: $modal.find(".modal-content"),
          width: $modal.data("width") || "500px",
          title: $modal.data("heading") || "",
          showCloseButton: true,
          showConfirmButton: false,
        }).then(
          function(confirm) { },
          function(dismiss) { }
        );
      })

      function appendPanel($heading, $reviewDiv) {
        var $panel = $('<div class="review-panel">'),
            $headingWrapper = $('<h4>');

        $headingWrapper.addClass('reset');
        $headingWrapper.text($heading.text());

        $headingWrapper.appendTo($panel);
        $panel.appendTo($reviewDiv);

        return $panel;
      }

      function appendLabels($panel, $labels) {
        $labels.each(function(idx, label) {
          var $label = $('<p>');

          if (label.dataset["subset"]) {
            $label.addClass("review-label-subset");
          } else {
            $label.addClass("review-label");
          }
          $label.text($(this).text());

          appendTextValue($panel, $label, $(this).next('input, textarea'));
          appendBooleanValue($panel, $label, $(this).prev('input'));
          removePartials($panel);
        });

        function appendTextValue($panel, $label, $input) {
          if ($input.is("textarea") || $input.prop('type') === "text") {
            $label.addClass('has-text-value');

            if (!$label.appended) {
              $label.appendTo($panel);
              $label.appended = true;
            }

            const $textValueElem = getTextValueElem($input);
            $textValueElem.appendTo($panel);

            appendTextValue($panel, $label, $input.next('input'));
          }
        }

        function appendBooleanValue($panel, $label, $input) {
          if ($input.length !== 0) {
            const $booleanValueElem = getBooleanValueElem($input);

            $label.append(" ");
            $booleanValueElem.appendTo($label);

            if ($input.prop('type') === "radio" && $input.prop('checked')) {
              $label.appendTo($panel);
            } else if ($input.prop('type') !== "radio") {
              $label.appendTo($panel);
            }
          }
        }

        function removePartials($panel) {
          $panel.find('.part-of-many').each(function() {
            const isPartOfMany = $(this).next('.part-of-many').length !== 0,

                  anyPartIsBlank = $(this).text() === "" ||
                    $(this).next('.part-of-many').text() === "";

            // Only works when many === 2,
            // but want name to imply that
            // this could extend

            if (isPartOfMany && anyPartIsBlank) {
              $(this).html(
                "<p class='hint'>Not filled in completely, nothing will appear.</p>"
              );
              $(this).next().remove();
            }
          });
        }

        function getBooleanValueElem($input) {
          if ($input.prop('type') !== "radio") {
            const value = $input.prop('checked') ? "yes" : "no",
                  cssClass = value === "yes" ? "on" : "off";

            var $value = $('<strong>');

            $value.addClass(cssClass);
            $value.text(value);

            return $value;
          } else {
            return $();
          }
        }

        function getTextValueElem($input) {
          var $value = $('<p>');

          if ($input.data("part-of-many")) {
            $value.addClass('part-of-many');
            $value.text($input.val());
          } else {
            $value.html(
              $input.val() ||
                "<p class='hint'>Not filled in, nothing will appear</p>"
            );
          }

          return $value;
        }
      }
    });
  }
});
