import Vue from "vue";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";

import LocationForm from "@appjs/location/components/LocationForm.vue";

describe("LocationForm", () => {
  beforeEach(() => {
    window.axios.get = vi.fn(() =>
      Promise.resolve({
        data: { city: "", state: "", country: "" },
      })
    );
    window.axios.patch = vi.fn(() =>
      Promise.resolve({
        status: 200,
        data: {
          results: [
            {
              city: "Oakland",
              state: "California",
              country: "United States",
            },
          ],
        },
      })
    );
    window.axios.post = vi.fn(() => Promise.resolve({ data: {} }));
  });

  it("loads current location on create when no value prop is provided", async () => {
    mount(LocationForm, {
      propsData: { scopeName: "student" },
    });

    await Vue.nextTick();

    expect(window.axios.get).toHaveBeenCalledWith("/student/current_location");
  });

  it("shows optional state label for Hong Kong", async () => {
    const wrapper = mount(LocationForm, {
      propsData: {
        scopeName: "student",
        value: { city: "", state: "", country: "Hong Kong" },
      },
    });

    expect(wrapper.text()).toContain("State / Province (Optional)");
  });

  it("submits location search and shows saved region", async () => {
    const wrapper = mount(LocationForm, {
      propsData: {
        scopeName: "student",
        value: { city: "", state: "", country: "" },
      },
    });

    await wrapper.find("#location_country").setValue("United States");
    await wrapper.find("#location_state").setValue("California");
    await wrapper.find("#location_city").setValue("Oakland");
    await wrapper.find("button.tw-green-btn").trigger("click");

    await Vue.nextTick();
    await Vue.nextTick();

    expect(window.axios.patch).toHaveBeenCalledWith(
      "/student/location",
      expect.objectContaining({
        student_location: expect.objectContaining({
          city: "Oakland",
          state: "California",
          country: "United States",
        }),
      })
    );
    expect(wrapper.text()).toContain("We have saved your region as:");
    expect(wrapper.text()).toContain("Oakland");
  });

  it("uses possessive copy for team scope", () => {
    const wrapper = mount(LocationForm, {
      propsData: {
        scopeName: "student",
        teamId: 42,
        value: { city: "Oakland", state: "CA", country: "US" },
      },
    });

    expect(wrapper.text()).toContain("this team's");
  });
});
