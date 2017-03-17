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
})();
