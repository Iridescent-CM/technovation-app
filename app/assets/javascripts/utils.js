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
