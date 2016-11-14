// Fancy Image Upload
// Add class "fancy-image-upload" to form containing file upload input,
// submit button, and optional label.
//
// <form class='fancy-image-upload'>
//   <label class="fancy-image-upload__drop-zone">
//     <span class="fancy-image-upload__label">Upload Screenshots</span>
//     <span class="fa fa-picture-o"></span>
//     <span  class="fancy-image-upload__label">Drop files here or click to browse</span>
//     <input type="file">
//   </label>
// </div>

setTimeout(fancyImageUpload, 0);

function fancyImageUpload() {
  var imageUploads = document.getElementsByClassName('fancy-image-upload');
  if (imageUploads.length === 0) {
    return;
  }
  var spanLabelClass = 'fancy-image-upload__label';
  var bottomLabelText = 'Drop files here or click to browse';
  for (var i = 0; i < imageUploads.length; i++) {
    var currentForm = imageUploads[i];
    var dropZone = document.createElement('label');
    dropZone.classList.add('fancy-image-upload__drop-zone');
    currentForm.insertBefore(dropZone, currentForm.firstChild);
    makeEmptyDropZone(dropZone);

    var fileInput = currentForm.querySelector('input[type="file"]');
    fileInput.addEventListener('change', setContent);
  }

  function setContent(e) {
    var input = e.target;
    var dropZone = input.parentElement;
    var fileCount = input.files.length;
    if (fileCount > 0) {
      var files = e.target.files;
      showFilesToUpload(dropZone, files);
    } else {
      makeEmptyDropZone(dropZone);
    }
  }

  function showFilesToUpload(dropZone, files) {
    var faImage = dropZone.querySelector('.fa');
    if (faImage) {
      faImage.remove();
    }
    var labels = dropZone.getElementsByClassName(spanLabelClass);
    if (labels.length > 1) {
      labels[1].remove();
    }
    var firstLabel = labels[0];
    firstLabel.innerHTML = 'Files to upload:'

    var filesListClass = 'fancy-image-upload__files-list';
    var existingFilesList = dropZone.querySelector('.' + filesListClass);
    if (existingFilesList) {
      existingFilesList.remove();
    }
    var filesList = document.createElement('ul');
    filesList.classList.add('fancy-image-upload__files-list');
    for (var i = 0; i < files.length; i++) {
      var file = files[i];
      var fileLi = document.createElement('li');
      fileLi.innerHTML = file.name;
      filesList.appendChild(fileLi);
    }
    dropZone.appendChild(filesList);
  }

  function makeEmptyDropZone(dropZone) {
    var form = dropZone.parentElement;
    // Selects a label that is NOT the drop zone
    var label = form.querySelectorAll('label')[1];
    if (label) {
      var labelText = label.innerHTML;
      var topLabel = document.createElement('span');
      topLabel.innerHTML = labelText;
      topLabel.classList.add(spanLabelClass);
      dropZone.appendChild(topLabel);
      label.style.display = 'none';
    }
    var faPictureIcon = document.createElement('span');
    faPictureIcon.classList.add('fa', 'fa-picture-o');
    dropZone.appendChild(faPictureIcon);
    var bottomLabel = document.createElement('span');
    bottomLabel.classList.add(spanLabelClass);
    bottomLabel.innerHTML = bottomLabelText;
    dropZone.appendChild(bottomLabel);
    if (!dropZone.querySelector('input[type="file"]')) {
      var fileInput = form.querySelector('input[type="file"]');
      dropZone.appendChild(fileInput);
    }
  }
};
