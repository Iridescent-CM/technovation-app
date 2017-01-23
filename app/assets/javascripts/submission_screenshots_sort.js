(function submissionEditScreenshots() {
  var mainWrapper = document.getElementById('submission-screenshots-edit');
  if (!mainWrapper) {
    return;
  }

  var baseClass = 'submission-screenshots-edit';

  var wrapper = document.getElementById('edit-screenshots-wrapper');
  var images = wrapper.getElementsByTagName('img');

  for (var i = 0; i < images.length; i++) {
    var currentImg = images[i];
    // Pull image ID out of URL. Kind of hacky, but it works.
    currentImg.dataset.id = currentImg.src.split('screenshot/image/')[1].split('/')[0];
    var dragHandle = document.createElement('span');
    dragHandle.classList.add('fa', 'fa-bars');
    currentImg.parentElement.insertBefore(dragHandle, currentImg);
    var label = document.createElement('span');
    label.classList.add(baseClass + '__label');
    label.innerText = currentImg.alt || "";
    currentImg.parentElement.insertBefore(label, currentImg);
  }

  var draggable = dragula([wrapper], {
    mirrorContainer: mainWrapper
  });

  draggable.on('drop', updateOrder);

  function updateOrder() {
    var items = wrapper.children;
    var order = Array.prototype.map.call(items, function(item) {
      return item.querySelector('img').dataset.id;
    });

    var path = mainWrapper.dataset.updateUrl;
    var payload = {};
    payload[mainWrapper.dataset.objectName] = {
      screenshots: order
    };

    console.log('PAYLOAD', payload);
    $.ajax(path, {
      method: 'PATCH',
      data: payload,
      success: function(res, status) {
        createFlashNotification('success', 'Screenshot order updated!');
      }
    });
  }

})();
