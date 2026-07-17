import { describe, expect, it, vi, beforeEach } from "vitest";

const notifyApiError = vi.fn();

vi.mock("utilities/apiErrorHandler", () => ({
  notifyApiError: (...args) => notifyApiError(...args),
}));

import { saveComment, updateScores } from "@appjs/judge/scores/store/mutations";

describe("judge score autosave mutations", () => {
  beforeEach(() => {
    notifyApiError.mockClear();
    global.$.ajax.mockClear();
  });

  describe("saveComment", () => {
    it("notifies the user and Airbrake on API failure", () => {
      const state = {
        score: { id: 7, comments: { pitch: { text: "solid pitch" } } },
      };

      saveComment(state, "pitch");

      const config = global.$.ajax.mock.calls[0][0];
      const jqXHR = { status: 500 };
      config.error(jqXHR, "error", "Internal Server Error");

      expect(notifyApiError).toHaveBeenCalledTimes(1);
      const arg = notifyApiError.mock.calls[0][0];
      expect(arg.error).toBe("Internal Server Error");
      expect(arg.jqXHR).toBe(jqXHR);
      expect(arg.context).toMatch(/JUDGING/);
      expect(arg.userMessage).toBeTruthy();
    });
  });

  describe("updateScores", () => {
    it("notifies the user and Airbrake on API failure", () => {
      const state = {
        score: { id: 7 },
        questions: [
          { section: "pitch", idx: 0, field: "pitch_score", score: 0 },
        ],
      };

      updateScores(state, { section: "pitch", idx: 0, score: 3 });

      const config = global.$.ajax.mock.calls[0][0];
      const jqXHR = { status: 422 };
      config.error(jqXHR, "error", "Unprocessable Entity");

      expect(notifyApiError).toHaveBeenCalledTimes(1);
      const arg = notifyApiError.mock.calls[0][0];
      expect(arg.jqXHR).toBe(jqXHR);
      expect(arg.context).toMatch(/JUDGING/);
      expect(arg.userMessage).toBeTruthy();
    });
  });
});
