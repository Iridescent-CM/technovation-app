(function multipleImageUpload() {
  var screenshotUploadForm = document.getElementById('team_submission_screenshots');
  var screenshotsModal = document.getElementById('screenshots-modal');
  if (!screenshotUploadForm) {
    return;
  }
  var inputArea = document.getElementById('image_uploader_screenshots');
  var submitButton = screenshotUploadForm.querySelector('input[type="submit"]');
  var dropZone;

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

    // Disable form while files are being uploaded
    submitButton.disabled = true;
    dropZone = screenshotUploadForm.querySelector('.fancy-image-upload__drop-zone');
    dropZone.classList.add('fancy-image-upload__drop-zone--loading');
    var spinner = document.createElement('span');
    spinner.classList.add('fa', 'fa-spinner', 'fa-pulse');
    dropZone.appendChild(spinner);

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

      $.ajax({
        type: 'POST',
        url: processImagesUrl,
        data: { keys: payload },
        success: function(res) {
          checkJobStatus(res['status_url']);
        }
      });
    }
  }

  function checkJobStatus(statusUrl) {
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
        resetUploadForm();
        updateGallery(res);
        updateEditScreenshots(res);
      }
    });
  }

  function resetUploadForm() {
    submitButton.disabled = false;
    dropZone.classList.remove('fancy-image-upload__drop-zone--loading');
    dropZone.querySelector('.fa-spinner').remove();
    screenshotsModal.querySelector('.modalify__close').click();
  }

  function updateGallery(images) {
    var screenshotsBody = document.querySelector('.ts-screenshots .card__body');
    var imageList = document.createElement('ul');
    imageList.classList.add('gallerify');

    images.forEach(function(img) {
      var imgEl = document.createElement('img');
      imgEl.src = img.image_url;
      imageList.appendChild(imgEl);
    });
    screenshotsBody.innerHTML = '';
    screenshotsBody.appendChild(imageList);
    var event = new CustomEvent('refreshgalleries', {bubbles: true, cancelable: true, detail: images});
    screenshotUploadForm.dispatchEvent(event);

    createFlashNotification('success', 'Images added!');
  }

  function updateEditScreenshots(res) {
    var editScreenshotsWrapper = document.getElementById('edit-screenshots-wrapper');
    editScreenshotsWrapper.innerHTML = '';
    res.forEach(function(item) {
      var li = document.createElement('li');
      var img = document.createElement('img');
      var a = document.createElement('a');
      img.dataset.imageId = item.id;
      img.setAttribute('width', '100%');
      img.src = item.image_url;
      a.classList.add('fa', 'fa-trash-o');
      a.dataset.remote = true;
      a.dataset.method =  'delete';
      a.dataset.confirm = 'Are you sure you want to delete the screenshot?';
      a.href = item.delete_url;
      li.appendChild(img);
      li.appendChild(a);
      editScreenshotsWrapper.appendChild(li);
    });
    var event = new Event('editscreenshotschanged', {bubbles: true, cancelable: true});
    editScreenshotsWrapper.dispatchEvent(event);
  }

})();
