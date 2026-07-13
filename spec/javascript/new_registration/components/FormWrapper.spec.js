import Vue from "vue";
import { describe, expect, it, beforeEach, afterEach, vi } from "vitest";
import { mount } from "@vue/test-utils";

import FormWrapper from "@appjs/new_registration/components/FormWrapper.vue";

describe("FormWrapper", () => {
  beforeEach(() => {
    document.body.innerHTML =
      '<form id="registration-form"></form><meta name="csrf-token" content="test-token" />';
    document.getElementById("registration-form").scrollIntoView = vi.fn();
  });

  afterEach(() => {
    document.body.innerHTML = "";
  });

  function mountFormWrapper() {
    return mount(FormWrapper, {
      attachTo: document.body,
      stubs: {
        FormulateForm: {
          template:
            '<form id="registration-form"><slot :isLoading="false" /></form>',
        },
        FormulateErrors: true,
        StepOne: { template: '<div class="step-one">Step 1</div>' },
        StudentStepTwo: {
          template: '<div class="student-step-two">Student step 2</div>',
        },
        JudgeStepTwo: {
          template: '<div class="judge-step-two">Judge step 2</div>',
        },
        MentorStepTwo: {
          template: '<div class="mentor-step-two">Mentor step 2</div>',
        },
        ChapterAmbassadorStepTwo: true,
        ClubAmbassadorStepTwo: true,
        StepThree: { template: '<div class="step-three">Step 3</div>' },
        StepFour: { template: '<div class="step-four">Step 4</div>' },
      },
    });
  }

  it("starts on step one of the registration wizard", () => {
    const wrapper = mountFormWrapper();

    expect(wrapper.vm.step).toBe(1);
    expect(wrapper.find(".step-one").exists()).toBe(true);
  });

  it("advances to the student profile step for student registrations", async () => {
    const wrapper = mountFormWrapper();
    wrapper.vm.formValues = { profileType: "student" };

    wrapper.vm.next();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.step).toBe(2);
    expect(wrapper.find(".student-step-two").exists()).toBe(true);
    expect(wrapper.find(".judge-step-two").exists()).toBe(false);
  });

  it("advances to the judge profile step for judge registrations", async () => {
    const wrapper = mountFormWrapper();
    wrapper.vm.formValues = { profileType: "judge" };

    wrapper.vm.next();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.step).toBe(2);
    expect(wrapper.find(".judge-step-two").exists()).toBe(true);
    expect(wrapper.find(".student-step-two").exists()).toBe(false);
  });

  it("moves forward and backward across later wizard steps", async () => {
    const wrapper = mountFormWrapper();

    wrapper.vm.next();
    wrapper.vm.next();
    wrapper.vm.next();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.step).toBe(4);
    expect(wrapper.find(".step-four").exists()).toBe(true);

    wrapper.vm.prev();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.step).toBe(3);
    expect(wrapper.find(".step-three").exists()).toBe(true);
  });

  it("prevents enter key from submitting the form early", () => {
    const wrapper = mountFormWrapper();
    const event = { which: 13, preventDefault: vi.fn() };

    wrapper.vm.onKeyPress(event);

    expect(event.preventDefault).toHaveBeenCalled();
  });
});
