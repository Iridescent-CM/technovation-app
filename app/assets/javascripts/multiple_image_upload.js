(function multipleImageUpload() {
  var screenshotUploadForm = document.getElementById('team_submission_screenshots');
  if (!screenshotUploadForm) {
    return;
  }
  var allowed = ['image/bmp', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'];
  var fileInput = screenshotUploadForm.querySelector('input[type="file"]');
  var formKeyElements = screenshotUploadForm.querySelectorAll('[type="hidden"][value]');
  var formKeyObj = {};
  Array.prototype.forEach.call(formKeyElements, function(el) {
    formKeyObj[el.name] = el.value;
  });

  screenshotUploadForm.addEventListener('submit', function(e) {
    e.preventDefault();
    var files = fileInput.files;

    //for (var i = 0; i < files.length; i++) {
    for (var i = 0; i < 1; i++) {
      var file = files[i];
      var isAllowed = allowed.indexOf(file.type) !== -1;
      if (isAllowed) {
        uploadFile(file);
      }
    }
  });

  function uploadFile(file) {
    var formData = new FormData();
    var formKeys = Object.keys(formKeyObj);
    formKeys.forEach(function(key) {
      if (key !== 'success_action_redirect') {
        formData.append(key, formKeyObj[key]);
      }
    });
    formData.append('file', file, file.name);

    $.ajax({
      url: screenshotUploadForm.action,
      data: formData,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      success: function(data){
          alert(data);
      }
    });
  }
})();
