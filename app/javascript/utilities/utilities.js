import AirbrakeClient from 'airbrake-js';

export const airbrake = new AirbrakeClient({
  projectId: process.env.AIRBRAKE_PROJECT_ID,
  projectKey: process.env.AIRBRAKE_PROJECT_KEY,
  environment: process.env.AIRBRAKE_RAILS_ENV,
});

export const isProduction = () => {
  return process.env.HOST_DOMAIN == "my.technovationchallenge.org"
}

export const isQa = () => {
  return process.env.HOST_DOMAIN == "technovation-qa.herokuapp.com"
}

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

export const urlHelpers = (() => {
  const publicMethods = {}

  publicMethods.getWindowSearch = () => {
    return window.location.search
  }

  publicMethods.fetchGetParameters = () => {
    return publicMethods.getWindowSearch()
      .slice(1)
      .split('&')
      .map((parameter) => {
        const keyValuePair = parameter.split('=')
        return {
          [`${keyValuePair[0]}`]: decodeURIComponent(keyValuePair[1]),
        }
      })
  }

  publicMethods.fetchGetParameterValue = (key) => {
    const parameters = publicMethods.fetchGetParameters()

    const foundParamater = parameters.find((parameter) => {
      return Boolean(parameter[key])
    })

    if (foundParamater && foundParamater[key]) {
      return foundParamater[key]
    }

    return foundParamater[key]
  }

  return publicMethods
})()
