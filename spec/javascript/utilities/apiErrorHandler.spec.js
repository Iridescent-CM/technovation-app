import { describe, expect, it, vi, beforeEach, afterEach } from "vitest";

const notify = vi.fn();

vi.mock("utilities/utilities", () => ({
  airbrake: { notify: (...args) => notify(...args) },
}));

import {
  notifyApiError,
  showUserFacingError,
  DEFAULT_API_ERROR_MESSAGE,
} from "@appjs/utilities/apiErrorHandler";

describe("apiErrorHandler", () => {
  beforeEach(() => {
    notify.mockClear();
    window.displayFlashMessage = vi.fn();
  });

  afterEach(() => {
    delete window.displayFlashMessage;
  });

  describe("notifyApiError", () => {
    it("notifies Airbrake with normalized axios request context", () => {
      const error = new Error("Request failed with status code 500");
      error.config = { method: "post", url: "/registration/email" };
      error.response = { status: 500, data: { message: "boom" } };

      notifyApiError({ error, context: "[REGISTRATION] save email" });

      expect(notify).toHaveBeenCalledTimes(1);
      const payload = notify.mock.calls[0][0];
      expect(payload.error).toBe(error);
      expect(payload.params).toEqual({
        context: "[REGISTRATION] save email",
        method: "POST",
        url: "/registration/email",
        status: 500,
        responseData: { message: "boom" },
      });
    });

    it("notifies Airbrake with normalized jQuery jqXHR context", () => {
      const jqXHR = { status: 422, responseJSON: { error: "nope" } };

      notifyApiError({
        error: "Unprocessable Entity",
        context: "[JUDGING] save score",
        jqXHR,
      });

      const payload = notify.mock.calls[0][0];
      expect(payload.params).toEqual({
        context: "[JUDGING] save score",
        status: 422,
        responseData: { error: "nope" },
      });
    });

    it("synthesizes an error when none is provided", () => {
      notifyApiError({ context: "[JUDGING] recusal" });

      const payload = notify.mock.calls[0][0];
      expect(payload.error).toBeInstanceOf(Error);
      expect(payload.error.message).toBe("[JUDGING] recusal");
    });

    it("shows user-visible error feedback with the error class", () => {
      notifyApiError({ error: new Error("x"), context: "ctx" });

      expect(window.displayFlashMessage).toHaveBeenCalledWith(
        DEFAULT_API_ERROR_MESSAGE,
        "error"
      );
    });

    it("uses a custom user message when supplied", () => {
      notifyApiError({
        error: new Error("x"),
        context: "ctx",
        userMessage: "Custom message",
      });

      expect(window.displayFlashMessage).toHaveBeenCalledWith(
        "Custom message",
        "error"
      );
    });
  });

  describe("showUserFacingError", () => {
    it("no-ops safely when displayFlashMessage is unavailable", () => {
      delete window.displayFlashMessage;

      expect(() => showUserFacingError("hi")).not.toThrow();
      expect(showUserFacingError("hi")).toBe(false);
    });
  });
});
