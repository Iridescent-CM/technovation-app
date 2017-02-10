(function () {
  enableConfirmSentence()

  function enableConfirmSentence() {
    var confirmField = document.querySelector("#account_confirm_sentence");

    if (!confirmField)
      return;

    confirmField.value = "";

    confirmField.addEventListener('keyup', function(e) {
      var actual = e.target.value.toLowerCase().replace(/[\,\.\!\_](?:\s\+$)?/gi, ''),
          expected = e.target.dataset.confirmSentence.toLowerCase(),
          form = e.target.closest('form');

      if (expected === actual) {
        form.classList.add('confirmed');
        form.querySelector('input[type="submit"]').removeAttribute('disabled');
      } else {
        form.classList.remove('confirmed');
        form.querySelector('input[type="submit"]').setAttribute('disabled', true);
      }
    });
  }
})();
