import Vue from "vue";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";

import BarChart from "@appjs/components/BarChart.vue";

const mockChartDestroy = vi.fn();
const MockChart = vi.fn(function Chart() {
  this.destroy = mockChartDestroy;
});

vi.mock("chart.js", () => ({
  default: MockChart,
}));

const mockChromaFn = vi.fn(() => ({
  alpha: vi.fn(() => ({
    rgba: vi.fn(() => [0, 0, 0, 1]),
  })),
}));

mockChromaFn.scale = vi.fn(() => ({
  mode: vi.fn(() => ({
    colors: vi.fn(() => ["#000000", "#ffffff"]),
  })),
}));

vi.mock("chroma-js", () => ({
  default: mockChromaFn,
}));

vi.mock("@appjs/utilities/chartjs-plugins", () => ({}));

function flushPromises() {
  return new Promise((resolve) => setTimeout(resolve, 0));
}

const sampleChartData = {
  labels: ["A", "B"],
  datasets: [{ data: [1, 2] }],
  urls: [["/a", "/b"]],
};

describe("BarChart", () => {
  beforeEach(() => {
    MockChart.mockClear();
  });

  it("lazy-loads chart.js and chroma-js then initializes the chart", async () => {
    const wrapper = mount(BarChart, {
      propsData: { chartData: sampleChartData },
      attachTo: document.body,
      stubs: { AppIcon: { template: "<span />" } },
    });

    await flushPromises();
    await Vue.nextTick();

    expect(MockChart).toHaveBeenCalled();
    expect(wrapper.vm.loading).toBe(false);

    wrapper.destroy();
  });
});
