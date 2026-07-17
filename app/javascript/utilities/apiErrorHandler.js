import { airbrake } from "utilities/utilities";

// Shared handler for API failures across the registration and judging Vue
// flows (issue #6293). It guarantees two things on every API error:
//   1. the user sees error feedback (via the global `displayFlashMessage`)
//   2. Airbrake is notified with normalized request context
export const DEFAULT_API_ERROR_MESSAGE =
  "Something went wrong. Please try again, and contact us if the problem continues.";

function extractRequestContext(error, jqXHR) {
  // jQuery `$.ajax` error handler: the jqXHR carries status/response.
  if (jqXHR) {
    return {
      status: jqXHR.status,
      responseData: jqXHR.responseJSON || jqXHR.responseText,
    };
  }

  // Axios error: request details live on `config`, response on `response`.
  if (error && error.config) {
    return {
      method: (error.config.method || "").toUpperCase(),
      url: error.config.url,
      status: error.response && error.response.status,
      responseData: error.response && error.response.data,
    };
  }

  return {};
}

// Renders user-visible error feedback. Uses the globally-provided
// `displayFlashMessage` (sprockets `flash-msgs.js`) when available and degrades
// safely when it is not (e.g. during unit tests).
export function showUserFacingError(message) {
  const text = message || DEFAULT_API_ERROR_MESSAGE;
  const flash =
    typeof displayFlashMessage === "function"
      ? displayFlashMessage
      : typeof window !== "undefined" &&
        typeof window.displayFlashMessage === "function"
      ? window.displayFlashMessage
      : null;

  if (flash) {
    flash(text, "error");
    return true;
  }

  return false;
}

export function notifyApiError({ error, context, userMessage, jqXHR } = {}) {
  const requestContext = extractRequestContext(error, jqXHR);
  const label = context || "API request failed";

  airbrake.notify({
    error: error || new Error(label),
    params: {
      context: label,
      ...requestContext,
    },
  });

  showUserFacingError(userMessage);
}
