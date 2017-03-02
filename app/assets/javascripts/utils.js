function defer(func, ms) {
  if (!ms) {
    ms = 0;
  }
  setTimeout(func, ms);
}

function findIndex(arr, func) {
  for (var i = 0; i < arr.length; i++) {
    if (func(arr[i])) {
      return i;
    }
  }
  return -1;
}

function forEach(arr, func) {
  Array.prototype.forEach.call(arr, func);
}

function closest(elem, selector, callback) {
  var closestFunc = window.Element.prototype.closest,
      parentElem;

  if (typeof closestFunc !== 'function') {
    parentElem = _getClosest(elem, selector);
  } else {
    parentElem = elem.closest(selector);
  }

  if (callback) {
    callback(parentElem);
  } else {
    return parentElem;
  }
}

function toArr(arrayLike) {
  if (arrayLike.length === undefined) {
    throw new Error('Argument passed to toArr() must have a length property');
  }
  var arr = [];
  for (var i = 0; i < arrayLike.length; i++) {
    arr.push(arrayLike[i]);
  }
  return arr;
}

var _getClosest = function ( elem, selector ) {
  // Element.matches() polyfill
  if (!Element.prototype.matches) {
    Element.prototype.matches =
      Element.prototype.matchesSelector ||
      Element.prototype.mozMatchesSelector ||
      Element.prototype.msMatchesSelector ||
      Element.prototype.oMatchesSelector ||
      Element.prototype.webkitMatchesSelector ||
      function(s) {
        var matches = (this.document || this.ownerDocument).querySelectorAll(s),
          i = matches.length;
        while (--i >= 0 && matches.item(i) !== this) {}
        return i > -1;
      };
  }

  // Get closest match
  for ( ; elem && elem !== document; elem = elem.parentNode ) {
    if ( elem.matches( selector ) ) return elem;
  }

  return null;
};

