export const isEmptyObject = (object) => {
  return Object.keys(object).length === 0 && object.constructor === Object
}

export const debounce = function (func, wait = 500) {
  let timeout

  return function(...args) {
    clearTimeout(timeout)

    timeout = setTimeout(() => {
      func.apply(this, args)
    }, wait)
  }
}