(function gallerify() {
  console.log('gallerify');
  var galleries = document.getElementsByClassName('gallerify');
  if (galleries.length === 0) {
    return;
  }
  for (var i = 0; i < galleries.length; i++) {
    var gallery = galleries[i];

    var galleryWrapper = document.createElement('div');
    galleryWrapper.classList.add('gallerify__wrapper');
    var activeImageWrapper = document.createElement('div');
    activeImageWrapper.classList.add('gallerify__main');
    var thumbs = document.createElement('div')
    thumbs.classList.add('gallerify__thumbs');
    galleryWrapper.appendChild(activeImageWrapper);
    galleryWrapper.appendChild(thumbs);

    var imageTags = gallery.getElementsByTagName('img');
    var images = Array.prototype.reduce.call(imageTags, function(r, img) {
      r.push({
        src: img.src,
        alt: img.alt
      })
      return r;
    }, []);

    var activeImage = document.createElement('img');
    var defaultImage = images[0];
    activeImage.src = defaultImage.src;
    activeImage.alt = defaultImage.alt;
    activeImageWrapper.appendChild(activeImage);

    if (images.length > 1) {
      var prevButton = document.createElement('div');
      prevButton.classList.add('gallerify__control', 'gallerify__control--prev');
      activeImageWrapper.appendChild(prevButton);
      prevButton.addEventListener('click', function() {
        handleControlButtonClick('prev');
      });

      var nextButton = document.createElement('div');
      nextButton.classList.add('gallerify__control', 'gallerify__control--next');
      activeImageWrapper.appendChild(nextButton);
      nextButton.addEventListener('click', function() {
        handleControlButtonClick('next');
      });
    }

    images.forEach(function(img, i) {
      console.log('I IS ', i);
      var thumbImageWrapper = document.createElement('div');
      thumbImageWrapper.classList.add('gallerify__thumb-img-wrapper');
      var thumbImage = document.createElement('img');
      thumbImage.classList.add('gallerify__thumb-img');
      thumbImage.src = img.src;
      thumbImage.alt = img.alt ? img.alt : '';
      thumbImageWrapper.appendChild(thumbImage);
      thumbs.appendChild(thumbImageWrapper);
      thumbImageWrapper.addEventListener('click', function() {
        setActiveImage(i);
      });
    });

    var activeIndex = 0;
    function setActiveImage(index) {
      activeIndex = index;
      activeImage.src = images[activeIndex].src;
      activeImage.alt = images[activeIndex].alt;
    }

    function handleControlButtonClick(direction) {
      var imageCount = images.length;
      var newIndex;
      if (direction === 'next') {
        newIndex = activeIndex >= (imageCount - 1) ? 0 : (activeIndex + 1);
      } else if (direction === 'prev') {
        newIndex = activeIndex <= 0 ? (imageCount - 1) : activeIndex - 1;
      } else {
        console.error('You must pass "next" or "prev" as direction to handleControlButtonClick');
      }
      setActiveImage(newIndex);
    }

    gallery.parentElement.insertBefore(galleryWrapper, gallery);
    gallery.remove();
  }
})();
