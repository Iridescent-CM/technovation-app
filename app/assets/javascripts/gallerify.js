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


    images.forEach(function(img) {
      var thumbImageWrapper = document.createElement('div');
      thumbImageWrapper.classList.add('gallerify__thumb-img-wrapper');
      var thumbImage = document.createElement('img');
      thumbImage.classList.add('gallerify__thumb-img');
      thumbImage.src = img.src;
      thumbImage.alt = img.alt ? img.alt : '';
      thumbImageWrapper.appendChild(thumbImage);
      thumbs.appendChild(thumbImageWrapper);
      thumbImageWrapper.addEventListener('click', function() {
        setActiveImage(img);
      });
    });

    function setActiveImage(img) {
      activeImage.src = img.src;
      activeImage.alt = img.alt;
    }



    gallery.parentElement.insertBefore(galleryWrapper, gallery);
    gallery.remove();
  }
})();
