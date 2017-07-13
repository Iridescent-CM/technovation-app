(function() {
  handleJudgingRoundChanges();

  function handleJudgingRoundChanges() {
    const $judgingRoundChoices = $('[name="season_toggles[judging_round]"]');

    if ($judgingRoundChoices.length === 0)
      return;

    const $container = $judgingRoundChoices.closest('fieldset'),

          $blockedByJudging = $('[data-blocked-by-judging]'),
          originalTextColor = $blockedByJudging.css('color'),

          store = localStorage,

          choices = {
            off: "off",
            qf: "qf",
            sf: "sf",
          },

          selectedChoiceOnLoad = $judgingRoundChoices.filter(function() {
            return $(this).prop('checked');
          })[0];

    var choicesMade = {};
    choicesMade[0] = selectedChoiceOnLoad.value;

    if (selectedChoiceOnLoad.value !== choices.off) {
      handleJudgingEnabled();
    }

    $judgingRoundChoices.on('change', function(e) {
      const choice = e.target.value;

      if (choice !== choices.off) {
        handleJudgingEnabled();
      } else {
        handleJudgingDisabled();
      }

      choicesMade[Object.keys(choicesMade).length] = choice;
    });

    $(window).unload(clearLocalStorage);

    function handleJudgingEnabled() {
      notifyUserOfEffect();
      disableSettingsBlockedByJudging();
      storeOriginalValuesLocally();
      setBlockedSettingsToOff();

      function notifyUserOfEffect() {
        var $notice = $('<div>');

        $notice.addClass('notice warning');
        $notice.text(
          "Turning judging on disables Submissions, Event Selection, and Scores!"
        );

        removeUserNotice();
        $container.append($notice);
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
        if (choicesMade[Object.keys(choicesMade).length - 1] !== choices.off)
          return;

        $blockedByJudging.each(function() {
          store[$(this).prop('id')] = $(this).prop('checked');
        });
      }

      function setBlockedSettingsToOff() {
        $blockedByJudging.prop('checked', false);
      }
    }

    function handleJudgingDisabled() {
      removeUserNotice();
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

    function removeUserNotice() {
      $container.find('.notice').remove();
    }

    function clearLocalStorage() {
      $blockedByJudging.each(function() {
        store.removeItem($(this).prop('id'));
      });
    }
  }
})();
