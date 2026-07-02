import AirbrakeClient from "airbrake-js";

const noopAirbrake = {
  notify: () => Promise.resolve({}),
  wrap: (fn) => fn,
  wrapArguments: (args) => args,
  call: (fn, ...args) => fn(...args),
};

const airbrakeProjectId = process.env.AIRBRAKE_PROJECT_ID;
const airbrakeProjectKey = process.env.AIRBRAKE_PROJECT_KEY;

const BROWSER_EXTENSION_SCHEMES = [
  "chrome-extension://",
  "moz-extension://",
  "safari-extension://",
  "safari-web-extension://",
];

function isBrowserExtensionNotice(notice) {
  return notice.errors.some((error) =>
    error.backtrace.some((frame) =>
      BROWSER_EXTENSION_SCHEMES.some((scheme) => frame.file.startsWith(scheme))
    )
  );
}

function createAirbrakeClient() {
  const client = new AirbrakeClient({
    projectId: airbrakeProjectId,
    projectKey: airbrakeProjectKey,
    environment: process.env.AIRBRAKE_RAILS_ENV,
  });
  client.addFilter((notice) => {
    if (isBrowserExtensionNotice(notice)) return null;

    // "Failed to fetch" comes from airbrake-js's own delivery fetch failing
    // (offline / tab closing / ad-blocker) — not from our app code. Attach
    // context so these entries are diagnosable in Airbrake (issue #6250).
    const isFailedToFetch = notice.errors.some(
      (e) => e.type === "TypeError" && /Failed to fetch/i.test(e.message || "")
    );
    if (isFailedToFetch) {
      notice.params = {
        ...notice.params,
        online: navigator.onLine,
        visibilityState: document.visibilityState,
        url: window.location.href,
      };
    }

    return notice;
  });
  return client;
}

export const airbrake =
  airbrakeProjectId && airbrakeProjectKey
    ? createAirbrakeClient()
    : noopAirbrake;

export const isProduction = () => {
  return process.env.HOST_DOMAIN == "my.technovationchallenge.org";
};

export const isQa = () => {
  return process.env.HOST_DOMAIN == "technovation-qa.herokuapp.com";
};

export const isEmptyObject = (object) => {
  return Object.keys(object).length === 0 && object.constructor === Object;
};

export const debounce = function (func, wait = 500) {
  let timeout;

  return function (...args) {
    clearTimeout(timeout);

    timeout = setTimeout(() => {
      func.apply(this, args);
    }, wait);
  };
};

export const urlHelpers = (() => {
  const publicMethods = {};

  publicMethods.getWindowSearch = () => {
    return window.location.search;
  };

  publicMethods.fetchGetParameters = () => {
    return publicMethods
      .getWindowSearch()
      .slice(1)
      .split("&")
      .map((parameter) => {
        const keyValuePair = parameter.split("=");
        return {
          [`${keyValuePair[0]}`]: decodeURIComponent(keyValuePair[1]),
        };
      });
  };

  publicMethods.fetchGetParameterValue = (key) => {
    const parameters = publicMethods.fetchGetParameters();

    const foundParamater = parameters.find((parameter) => {
      return Boolean(parameter[key]);
    });

    if (foundParamater && foundParamater[key]) {
      return foundParamater[key];
    }

    return foundParamater[key];
  };

  return publicMethods;
})();
