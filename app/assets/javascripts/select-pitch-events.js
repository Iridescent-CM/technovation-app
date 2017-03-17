(function() {
  var eventInputs = document.querySelectorAll(
    '.mentor-regional-pitch-events__team-review input[type=radio]'
  );

  forEach(eventInputs, function(input) {
    input.addEventListener('change', function(e) {
      var i = e.target;

      if (i.checked) {
        closest(i, 'ul', function(el) {
          el.querySelector('.selected').classList.remove('selected');
        });

        closest(i, 'label', function(el) {
          el.classList.add('selected');
        });
      }
    });
  });
})();
