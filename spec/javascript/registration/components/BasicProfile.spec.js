import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it, vi } from "vitest";
import { mount } from "@vue/test-utils";

import BasicProfile from "@appjs/registration/components/BasicProfile.vue";
import getters from "@appjs/registration/store/getters";
import mutations from "@appjs/registration/store/mutations";

Vue.use(Vuex);

function buildRegistrationState(overrides = {}) {
  return {
    termsAgreed: true,
    birthYear: "2010",
    birthMonth: { label: "01 - January", value: "1" },
    birthDay: "15",
    cutoff: new Date(2026, 7, 1),
    profileChoice: "student",
    country: "United States",
    firstName: "",
    lastName: "",
    schoolCompanyName: "",
    jobTitle: null,
    mentorType: null,
    genderIdentity: null,
    bio: "",
    expertiseIds: [],
    referredBy: null,
    referredByOther: null,
    months: [{ label: "01 - January", value: "1" }],
    ...overrides,
  };
}

function mountBasicProfile(stateOverrides = {}) {
  window.axios.get = vi.fn(() =>
    Promise.resolve({ data: { attributes: [] } })
  );

  const store = new Vuex.Store({
    modules: {
      registration: {
        namespaced: true,
        state: buildRegistrationState(stateOverrides),
        getters,
        mutations,
        actions: {
          updateBasicProfile: vi.fn(() => Promise.resolve()),
        },
      },
    },
  });

  const wrapper = mount(BasicProfile, {
    store,
    mocks: {
      $router: {
        push: vi.fn(),
        replace: vi.fn(),
      },
    },
    stubs: {
      "vue-select": {
        template: '<select class="vue-select-stub"><slot /></select>',
      },
    },
  });

  return { wrapper, store };
}

describe("BasicProfile", () => {
  it("disables next until student profile fields are complete", async () => {
    const { wrapper } = mountBasicProfile({ profileChoice: "student" });

    expect(wrapper.find("button").attributes("disabled")).toBe("disabled");

    await wrapper.find("#firstName").setValue("Ada");
    await wrapper.find("#lastName").setValue("Lovelace");
    await wrapper.find("#schoolName").setValue("Analytical School");

    expect(wrapper.find("button").attributes("disabled")).toBeUndefined();
  });

  it("shows school label for students and company label for mentors", async () => {
    const student = mountBasicProfile({ profileChoice: "student" });
    const mentor = mountBasicProfile({ profileChoice: "mentor" });

    expect(student.wrapper.text()).toContain("School name");
    expect(mentor.wrapper.text()).toContain("School or company name");
  });

  it("requires mentor bio of at least 100 characters before enabling next", async () => {
    const { wrapper } = mountBasicProfile({
      profileChoice: "mentor",
      firstName: "Grace",
      lastName: "Hopper",
      schoolCompanyName: "Navy",
      jobTitle: "Admiral",
      mentorType: "Industry professional",
      genderIdentity: "Female",
      bio: "short",
    });

    expect(wrapper.find("button").attributes("disabled")).toBe("disabled");

    await wrapper.find("#bio").setValue("a".repeat(100));

    expect(wrapper.find("button").attributes("disabled")).toBeUndefined();
  });
});
