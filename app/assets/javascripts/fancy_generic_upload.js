// Add 'fancy-file-upload' class to form wrapper
// <%= direct_upload_form_for @pitch_presentation_uploader,
//                            html: {class: 'fancy-file-upload'} do |f| %>
//   <%= f.file_field :pitch_presentation %>
//   <%= f.submit t("views.application.upload"), class: "appy-button" %>
// <% end %>

(function() {
  setTimeout(fancyFileUplodad, 0);

  function fancyFileUplodad() {
    var fileUploads = document.getElementsByClassName('fancy-file-upload');
    if (fileUploads.length === 0) {
      return;
    }
    var spanLabelClass = 'fancy-file-upload__label';
    var dropZoneClass = 'fancy-file-upload__drop-zone';
    var bottomLabelText = 'Drop files here or click to browse';
    for (var i = 0; i < fileUploads.length; i++) {
      var currentForm = fileUploads[i];
      var dropZone = document.createElement('label');
      dropZone.classList.add(dropZoneClass);

      var submitButton = currentForm.querySelector('[type="submit"]');
      currentForm.insertBefore(dropZone, submitButton);

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

      var filesListClass = 'fancy-file-upload__files-list';
      var existingFilesList = dropZone.querySelector('.' + filesListClass);
      if (existingFilesList) {
        existingFilesList.remove();
      }
      var filesList = document.createElement('ul');
      filesList.classList.add('fancy-file-upload__files-list');
      for (var i = 0; i < files.length; i++) {
        var file = files[i];
        var fileListItem = document.createElement('li');
        fileListItem.innerHTML = file.name;
        filesList.appendChild(fileListItem);
      }
      dropZone.appendChild(filesList);
    }

    function makeEmptyDropZone(dropZone) {
      var form = dropZone.parentElement;
      // Selects a label that is NOT the drop zone
      var label = form.querySelector('label:not(.' + dropZoneClass + ')');
      if (label) {
        var labelText = label.innerHTML;
        var topLabel = document.createElement('span');
        topLabel.innerHTML = labelText;
        topLabel.classList.add(spanLabelClass);
        dropZone.appendChild(topLabel);
        label.style.display = 'none';
      }
      var faFileIcon = document.createElement('span');
      faFileIcon.classList.add('fa', 'fa-file-o');
      dropZone.appendChild(faFileIcon);
      var bottomLabel = document.createElement('span');
      bottomLabel.classList.add(spanLabelClass);
      bottomLabel.innerHTML = bottomLabelText;
      dropZone.appendChild(bottomLabel);
      if (!dropZone.querySelector('input[type="file"]')) {
        var fileInput = form.querySelector('input[type="file"]');
        dropZone.appendChild(fileInput);
      }
    }
  }
})();
