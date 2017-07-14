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
    const $saveBtn = $('[data-submit-form]');
    handleSaveBtnClick($saveBtn);

    function handleSaveBtnClick($btn) {
      $btn.on('click', function() {
        const formId = $(this).data('submit-form');
        $(formId).submit();
      });
    }
  }
})();
