import Vue from "vue";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";

import ScreenshotUploader from "@appjs/components/ScreenshotUploader.vue";

const mockPickerOpen = vi.fn();
const mockInit = vi.fn(() => ({
  picker: vi.fn(() => ({ open: mockPickerOpen })),
}));

vi.mock("filestack-js", () => ({
  init: (...args) => mockInit(...args),
}));

function flushPromises() {
  return new Promise((resolve) => setTimeout(resolve, 0));
}

describe("ScreenshotUploader", () => {
  beforeEach(() => {
    mockInit.mockClear();
    mockPickerOpen.mockClear();

    window.vueDragula = {
      eventBus: { $on: vi.fn() },
    };
    window.axios.get = vi.fn(() => Promise.resolve({ data: [] }));

    process.env.FILESTACK_API_KEY = "test-key";
    process.env.AWS_BUCKET_NAME = "test-bucket";
  });

  it("dynamically loads filestack-js when upload is clicked", async () => {
    const wrapper = mount(ScreenshotUploader, {
      propsData: {
        sortUrl: "/sort",
        screenshotsUrl: "/screenshots",
        teamId: 1,
        teamSubmissionId: 42,
      },
    });

    await Vue.nextTick();

    await wrapper.find("button").trigger("click");
    await flushPromises();
    await Vue.nextTick();

    expect(mockInit).toHaveBeenCalledWith("test-key");
    expect(mockPickerOpen).toHaveBeenCalled();

    wrapper.destroy();
  });
});
