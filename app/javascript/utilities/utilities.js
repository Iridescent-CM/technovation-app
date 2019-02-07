import AirbrakeClient from 'airbrake-js';

let airbrakeEnvironment = 'development';
if (!!process && !!process.env && !!process.env.AIRBRAKE_RAILS_ENV) {
  airbrakeEnvironment = process.env.AIRBRAKE_RAILS_ENV;
}

export const airbrake = new AirbrakeClient({
  projectId: 107438,
  projectKey: '25c7abb3eb366a19a0743c5f04a9320e',
  environment: airbrakeEnvironment,
});

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
