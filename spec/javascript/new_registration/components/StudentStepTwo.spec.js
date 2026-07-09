import Vue from "vue";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import StudentStepTwo from "@appjs/new_registration/components/StudentStepTwo.vue";

const formulateInputStub = {
  props: ["name", "id", "type", "label", "validation"],
  template: `
    <div>
      <label>{{ label }}</label>
      <input
        :id="id || name"
        :name="name"
        :type="type || 'text'"
        @input="$emit('input', $event.target.value)"
        @keyup="$emit('keyup', $event)"
        @blur="$emit('blur', $event)"
        @change="$emit('change', $event)"
      />
    </div>
  `,
};

function mountStudentStepTwo(profileType = "student") {
  const attachTo = document.createElement("div");
  document.body.appendChild(attachTo);

  const wrapper = mount(StudentStepTwo, {
    attachTo,
    propsData: {
      formValues: {
        profileType,
        email: "",
      },
    },
    stubs: {
      ContainerHeader: { template: "<h1><slot /></h1>" },
      ReferredBy: true,
      PreviousButton: { template: "<button type='button'>Back</button>" },
      NextButton: {
        props: ["disabled"],
        template:
          '<button type="button" class="next-button" :disabled="disabled">Next</button>',
      },
      FormulateInput: formulateInputStub,
    },
  });

  return { wrapper, attachTo };
}

function nextButton(wrapper) {
  return wrapper.find("button.next-button");
}

function fillRequiredStudentFields(wrapper, { profileType = "student" } = {}) {
  const birthday =
    profileType === "parent" ? "2016-05-15" : "2010-05-15";

  wrapper.find("#firstName").element.value = "Ada";
  wrapper.find("#lastName").element.value = "Lovelace";
  wrapper.find("#dateOfBirth").element.value = birthday;
  wrapper.find("#studentSchoolName").element.value = "Analytical School";
  wrapper.find("#studentParentGuardianName").element.value = "Grace Hopper";
}

describe("StudentStepTwo", () => {
  it("keeps next disabled until required student fields are filled", async () => {
    const { wrapper } = mountStudentStepTwo();

    expect(nextButton(wrapper).attributes("disabled")).toBeDefined();

    fillRequiredStudentFields(wrapper);
    wrapper.vm.checkValidation();
    await wrapper.vm.$nextTick();

    expect(nextButton(wrapper).attributes("disabled")).toBeUndefined();
  });

  it("shows division cutoff age guidance for the entered birthday", async () => {
    const { wrapper } = mountStudentStepTwo();

    await wrapper.find("#dateOfBirth").setValue("2010-05-15");
    await wrapper.vm.$nextTick();

    expect(wrapper.text()).toContain("August 1, 2026");
    expect(wrapper.text()).toContain("years old by this date");
  });

  it("requires parent email when registering through the parent flow", async () => {
    const { wrapper } = mountStudentStepTwo("parent");

    fillRequiredStudentFields(wrapper, { profileType: "parent" });
    document.getElementById("studentParentGuardianEmail").value = "";
    wrapper.vm.checkValidation();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.hasValidationErrors).toBe(true);

    document.getElementById("studentParentGuardianEmail").value =
      "parent@example.com";
    wrapper.vm.checkValidation();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.hasValidationErrors).toBe(false);
  });

  it("uses parent-specific copy for age guidance", () => {
    const { wrapper } = mountStudentStepTwo("parent");

    expect(wrapper.text()).toContain("this student");
    expect(wrapper.text()).toContain("Parent Email Address");
  });
});
