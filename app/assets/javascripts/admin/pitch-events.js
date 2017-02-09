(function() {
  enableRemoteUnofficialCheckbox();

  function enableRemoteUnofficialCheckbox() {
    var checkbox = document.querySelector('#regional_pitch_event_unofficial');

    if (!checkbox)
      return;

    checkbox.addEventListener('change', function(e) {
      e.target.closest('form').submit();
    });
  }
})();
