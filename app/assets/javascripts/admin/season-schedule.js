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
    const $container = $choices.closest('fieldset'),

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
      notifyUserOfEffect();
      disableSettingsBlockedByJudging();
      storeOriginalValuesLocally();
      $blockedByJudging.prop('checked', false);

      function notifyUserOfEffect() {
        if ($container.find('.notice').length === 0) {
          var $notice = $('<div>');

          $notice.addClass('notice warning');
          $notice.text(
            "Turning judging on disables Submissions, Event Selection, and Scores!"
          );

          $container.append($notice);
        }
      }

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
    }

    function handleJudgingDisabled() {
      $container.find('.notice').remove();
      enableSettingsBlockedByJudging();
      restoreOriginalValues();
      clearLocalStorage();

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

        $('legend').each(function() {
          var $panel = appendPanel($(this), $div);

          appendLabels($panel, $(this).closest('fieldset').find('label'));
        })

        function appendPanel($heading, $div) {
          var $panel = $('<div class="review-panel">'),
              $p = $('<p>');

          $p.addClass('heading');
          $p.text($heading.text());

          $p.appendTo($panel);
          $panel.appendTo($div);

          return $panel;
        }

        function appendLabels($panel, $labels) {
          $labels.each(function() {
            var $p = $('<p>');

            $p.text($(this).text());

            appendTextValue($panel, $p, $(this).next('input'));
            appendBooleanValue($panel, $p, $(this).prev('input'));
            removePartials($panel);
          });

          function appendTextValue($panel, $p, $input) {
            if ($input.prop('type') === "text") {
              $p.addClass('has-text-value');

              if (!$p.appended) {
                $p.appendTo($panel);
                $p.appended = true;
              }

              const $textValueElem = getTextValueElem($input);
              $textValueElem.appendTo($panel);

              appendTextValue($panel, $p, $input.next('input'));
            }
          }

          function appendBooleanValue($panel, $p, $input) {
            if ($input.length !== 0) {
              const $booleanValueElem = getBooleanValueElem($input);

              $p.append(" ");
              $booleanValueElem.appendTo($p);

              if ($input.prop('type') === "radio" && $input.prop('checked')) {
                $p.appendTo($panel);
              } else if ($input.prop('type') !== "radio") {
                $p.appendTo($panel);
              }
            }
          }

          function removePartials($panel) {
            var $manies = $panel.find('.part-of-many');
            $manies.each(function() {
              if (
                $(this).next('.part-of-many').length !== 0 && (
                  $(this).text() === "" ||
                    $(this).next('.part-of-many').text() === ""
                )
              ) {
                $(this).html(
                  "<p class='hint'>not filled in completely, nothing will appear</p>"
                );
                $(this).next().remove();
              }
            });
          }

          function getBooleanValueElem($input) {
            if ($input.prop('type') !== "radio") {
              const value = $input.prop('checked'),
                    cssClass = value ? "on" : "off";

              var $strong = $('<strong>');

              $strong.addClass(cssClass);
              $strong.text(value);

              return $strong;
            } else {
              return $();
            }
          }

          function getTextValueElem($input) {
            var $p = $('<p>');

            if ($input.data("part-of-many")) {
              $p.addClass('part-of-many');
              $p.text($input.val());
            } else {
              $p.html(
                $input.val() ||
                  "<p class='hint'>Not filled in, nothing will appear</p>"
              );
            }

            return $p;
          }
        }
      });
    }
  }
})();
