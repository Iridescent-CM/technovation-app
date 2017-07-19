(function() {
  const $judgingRoundChoices = $('[name="season_toggles[judging_round]"]'),
        $scheduleForm = $('#season_schedule');

  if ($judgingRoundChoices.length === 0) {
    return;
  } else {
    handleJudgingRoundChanges($judgingRoundChoices);
    handleSeasonSettingsReview($scheduleForm);
  }

  function handleJudgingRoundChanges($choices) {
    const $container = $choices.closest('.tab-content'),

          $blockedByJudging = $('[data-blocked-by-judging]'),
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

    $(window).unload(clearLocalStorage);

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
          $notice.text("Enabling judging has affected other season features.");

          $container.append($notice);
        }

        $('[disabled]:not(.user-notified').each(function() {
          const $tab = $(this).closest('.tab-content');

          var $notice = $('<div>');

          $notice.addClass('notice info hint user-notice');
          $notice.text("When judging is enabled, " + $(this).data('when-blocked'));

          $(this).next('label').after($notice);

          const $menuItem = $('.tab-menu').find(
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
    const $saveBtn = $('[data-submit-form]'),
          $reviewDiv = $('#season_review');

    handleSaveBtnClick($saveBtn);
    populateSeasonReview($reviewDiv, $form);

    function handleSaveBtnClick($btn) {
      $btn.on('click', function() {
        const formId = $(this).data('submit-form');
        $(formId).submit();
      });
    }

    function populateSeasonReview($div, $form) {
      $form.find('[data-modal-trigger]').on('modalopen', function() {
        $div.html("");

        $('h4').each(function() {
          var $panel = appendPanel($(this), $div);

          appendLabels($panel, $(this).closest('.tab-content').find('label'));
        });

        function appendPanel($heading, $div) {
          var $panel = $('<div class="review-panel">'),
              $headingWrapper = $('<p>');

          $headingWrapper.addClass('heading');
          $headingWrapper.text($heading.text());

          $headingWrapper.appendTo($panel);
          $panel.appendTo($div);

          return $panel;
        }

        function appendLabels($panel, $labels) {
          $labels.each(function() {
            var $label = $('<p>');

            $label.text($(this).text());

            appendTextValue($panel, $label, $(this).next('input'));
            appendBooleanValue($panel, $label, $(this).prev('input'));
            removePartials($panel);
          });

          function appendTextValue($panel, $label, $input) {
            if ($input.prop('type') === "text") {
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
              const value = $input.prop('checked'),
                    cssClass = value ? "on" : "off";

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
  }
})();
