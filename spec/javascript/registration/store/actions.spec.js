import { describe, expect, it, vi, beforeEach } from "vitest";

const notifyApiError = vi.fn();

vi.mock("utilities/apiErrorHandler", () => ({
  notifyApiError: (...args) => notifyApiError(...args),
}));

import actions from "@appjs/registration/store/actions";

function flushMicrotasks() {
  return new Promise((resolve) => setTimeout(resolve, 0));
}

describe("registration autosave actions", () => {
  beforeEach(() => {
    notifyApiError.mockClear();
  });

  it("saveEmail surfaces feedback and notifies Airbrake on failure", async () => {
    const error = new Error("network down");
    global.axios.post = vi.fn(() => Promise.reject(error));

    actions.saveEmail(
      { state: { wizardToken: "token" } },
      { email: "ada@example.com" }
    );
    await flushMicrotasks();

    expect(notifyApiError).toHaveBeenCalledWith(
      expect.objectContaining({
        error,
        context: expect.stringMatching(/REGISTRATION/),
      })
    );
  });

  it("updateBasicProfile surfaces feedback and notifies Airbrake on failure", async () => {
    const error = new Error("server error");
    global.axios.patch = vi.fn(() => Promise.reject(error));

    await actions.updateBasicProfile(
      { state: { apiMethod: "patch", apiRoot: "student", wizardToken: "t" } },
      {}
    );

    expect(notifyApiError).toHaveBeenCalledWith(
      expect.objectContaining({
        error,
        context: expect.stringMatching(/REGISTRATION/),
      })
    );
  });
});
