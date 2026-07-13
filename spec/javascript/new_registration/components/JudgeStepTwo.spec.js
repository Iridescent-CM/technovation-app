import Vue from "vue";
import { describe, expect, it, vi, beforeEach, afterEach } from "vitest";

import axios from "axios";
import JudgeStepTwo from "@appjs/new_registration/components/JudgeStepTwo.vue";
import {
  formulateInputStub,
  mountWithAttachTo,
} from "../../support/formulateStubs";

vi.mock("axios", () => ({
  default: {
    get: vi.fn(),
  },
}));

async function mountJudgeStepTwo() {
  axios.get.mockResolvedValue({
    data: [{ id: 1, name: "Industry professional" }],
  });

  const mounted = mountWithAttachTo(JudgeStepTwo, {
    propsData: {
      formValues: {
        profileType: "judge",
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

  await Vue.nextTick();
  await Vue.nextTick();

  return mounted;
}

function nextButton(wrapper) {
  return wrapper.find("button.next-button");
}

function fillRequiredJudgeFields(wrapper) {
  wrapper.find("#firstName").element.value = "Ada";
  wrapper.find("#lastName").element.value = "Lovelace";
  document.getElementById("meetsMinimumAgeRequirement").checked = true;
  wrapper.find("#dateOfBirth").element.value = "1990-05-15";
  wrapper.find("#judgeSchoolCompanyName").element.value = "Technovation";
  wrapper.find("#judgeJobTitle").element.value = "Engineer";

  const judgeTypeCheckbox = document.querySelector('[name="judgeTypes"]');
  judgeTypeCheckbox.checked = true;
}

describe("JudgeStepTwo", () => {
  beforeEach(() => {
    document.body.innerHTML = "";
    vi.clearAllMocks();
  });

  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("loads judge type options on create", async () => {
    const { wrapper } = await mountJudgeStepTwo();

    expect(axios.get).toHaveBeenCalledWith("/api/registration/judge_types");
    expect(wrapper.vm.judgeTypeOptions).toHaveLength(1);
  });

  it("keeps next disabled until required judge fields are complete", async () => {
    const { wrapper } = await mountJudgeStepTwo();

    expect(nextButton(wrapper).attributes("disabled")).toBeDefined();

    fillRequiredJudgeFields(wrapper);
    wrapper.vm.checkValidation();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.hasValidationErrors).toBe(false);
    expect(nextButton(wrapper).attributes("disabled")).toBeUndefined();
  });

  it("requires the 18+ confirmation checkbox", async () => {
    const { wrapper } = await mountJudgeStepTwo();

    fillRequiredJudgeFields(wrapper);
    document.getElementById("meetsMinimumAgeRequirement").checked = false;
    wrapper.vm.checkValidation();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.hasValidationErrors).toBe(true);
  });

  it("requires at least one judge type selection", async () => {
    const { wrapper } = await mountJudgeStepTwo();

    fillRequiredJudgeFields(wrapper);
    document.querySelector('[name="judgeTypes"]').checked = false;
    wrapper.vm.checkValidation();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.hasValidationErrors).toBe(true);
  });
});
