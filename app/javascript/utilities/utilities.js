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

export const fetchGetParameters = function () {
  return window.location.search.slice(1).split('&')
    .map((parameter) => {
      const keyValuePair = parameter.split('=')
      return {
        [`${keyValuePair[0]}`]: decodeURIComponent(keyValuePair[1]),
      }
    })
}

export const fetchGetParameterValue = function (key) {
  const parameters = fetchGetParameters()

  const foundParamater = parameters.find((parameter) => {
    return Boolean(parameter[key])
  })

  if (foundParamater && foundParamater[key]) {
    return foundParamater[key]
  }

  return foundParamater[key]
}