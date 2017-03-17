(function() {
  var eventInputs = document.querySelectorAll(
    '.mentor-regional-pitch-events__team-review input[type=radio]'
  );

  forEach(eventInputs, function(input) {
    input.addEventListener('change', function(e) {
      selectInput(e.target);
    });
  });

  var modalSelectBtns = document.querySelectorAll(
    '.mentor-regional-pitch-events__team-review .modal-actions button'
  );

  forEach(modalSelectBtns, function(btn) {
    btn.addEventListener('click', function(e) {
      selectInput(document.getElementById(e.target.dataset.selects));
    });
  });

  function selectInput(i) {
    closest(i, 'ul', function(el) {
      el.querySelector('.selected').classList.remove('selected');

      i.checked = true;

      closest(i, 'label', function(el) {
        el.classList.add('selected');
      });
    });
  }

  var saveBtns = document.querySelectorAll('.save-mentor-pitch-events');

  forEach(saveBtns, function(btn) {
    btn.addEventListener('click', function(e) {
      var b = e.target,
          body = {
            regional_pitch_events_teams: {},
          },
          teams = document.querySelectorAll('.team-card');

      forEach(teams, function(team) {
        var checkedEvent = team.querySelector(':checked');

        if (!checkedEvent)
          return;

        var event_id = team.querySelector(':checked').value,
            team_id = team.dataset.teamId;

        body.regional_pitch_events_teams[team_id] = event_id;
      });

      $.ajax(b.dataset.url, {
        method: "POST",
        data: body,
        success: function() {
          createFlashNotification('success', 'Changes were saved!');
        },
        error: function() {
          createFlashNotification('error', 'Sorry, there was a problem. Please try again.');
        }
      });
    });
  });
})();
