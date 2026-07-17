import Vue from "vue";
import { describe, expect, it, vi } from "vitest";
import { mount } from "@vue/test-utils";

import PasswordInput from "@appjs/registration/components/PasswordInput.vue";

vi.mock("vue-password-strength-meter", () => ({
  default: {
    name: "PasswordStub",
    template: '<input class="password-stub" />',
    props: {
      value: { default: "" },
      toggle: Boolean,
      secureLength: Number,
    },
  },
}));

describe("PasswordInput", () => {
  it("registers vue-password-strength-meter as an async component factory", () => {
    expect(typeof PasswordInput.components.Password).toBe("function");
  });

  it("resolves the password meter module via dynamic import", async () => {
    const module = await PasswordInput.components.Password();

    expect(module.default.name).toBe("PasswordStub");
  });

  it("renders the password form shell", () => {
    const wrapper = mount(PasswordInput, {
      stubs: { Password: { template: '<input class="password-stub" />' } },
    });

    expect(wrapper.find("label").text()).toBe("Password");
    expect(wrapper.find(".password-stub").exists()).toBe(true);

    wrapper.destroy();
  });
});
