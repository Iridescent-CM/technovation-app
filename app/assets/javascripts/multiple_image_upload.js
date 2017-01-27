(function multipleImageUpload() {
  var screenshotUploadForm = document.getElementById('team_submission_screenshots');
  if (!screenshotUploadForm) {
    return;
  }
  var allowed = ['image/bmp', 'image/jpg', 'image/jpeg', 'image/gif', 'image/png'];
  var awsKey = screenshotUploadForm.querySelector('input[name="key"]').value;
  var fileInput = screenshotUploadForm.querySelector('input[type="file"]');
  var formKeyElements = screenshotUploadForm.querySelectorAll('[type="hidden"][value]');
  var processImagesUrl = screenshotUploadForm.dataset.processImagesUrl;
  var screenshotsUrl = screenshotUploadForm.dataset.screenshotsUrl;
  var formKeyObj = {};
  // pendingUploads is an array of objects where each looks like:
  // { fileName: foo.png, status: ['fresh', 'pending', 'success', 'error']}
  var pendingUploads = [];

  forEach(formKeyElements, function(el) {
    formKeyObj[el.name] = el.value;
  });

  screenshotUploadForm.addEventListener('submit', function(e) {
    e.preventDefault();
    var files = fileInput.files;

    forEach(files, function(file) {
      var isAllowed = allowed.indexOf(file.type) !== -1;
      if (isAllowed) {
        pendingUploads.push({
          fileName: file.name,
          status: 'fresh'
        });
        defer(function() {
          uploadFile(file);
        });
      }
    });
    handleUploadCompletion();
  });

  function uploadFile(file) {
    var formData = new FormData();
    var formKeys = Object.keys(formKeyObj);
    formKeys.forEach(function(key) {
      formData.append(key, formKeyObj[key]);
    });
    formData.append('file', file, file.name);

    var fileIndex = findIndex(pendingUploads, function(item) {
      return item.fileName === file.name;
    });

    pendingUploads[fileIndex].status = 'pending';

    $.ajax({
      type: 'POST',
      url: screenshotUploadForm.action,
      data: formData,
      cache: false,
      contentType: false,
      processData: false,
      success: function(data) {
        pendingUploads[fileIndex].status = 'success';
      },
      error: function(err) {
        // TODO: Handle errors
        console.error(err);
      }
    });
  }

  function handleUploadCompletion() {
    var isDone = pendingUploads.reduce(function(r, item) {
      // TODO: Add error handling
      return r || (item.status == 'success');
    }, false);
    if (!isDone) {
      setTimeout(handleUploadCompletion, 100);
    } else {
      var payload = [];
      pendingUploads.forEach(function(item) {
        payload.push(awsKey.replace('${filename}', item.fileName));
      });
      console.log(payload);
      $.ajax({
        type: 'POST',
        url: processImagesUrl,
        data: { keys: payload },
        success: function(res) {
          console.log('OG res', res);
          checkJobStatus(res['status_url']);
        }
      });
    }
  }

  function checkJobStatus(statusUrl) {
    console.log(statusUrl);
    $.ajax({
      type: 'GET',
      url: statusUrl,
      success: function(res) {
        if (res.status === 'complete') {
          handleImageProcessing();
        } else {
          setTimeout(function() {
            checkJobStatus(statusUrl);
          }, 1000);
        }
      }
    });
  }

  function handleImageProcessing() {
    $.ajax({
      type: 'GET',
      url: screenshotsUrl,
      success: function(res) {
        console.log('WE HAVE THE STUFF');
        console.log('Procesed images', res);
      }
    });
  }

})();
