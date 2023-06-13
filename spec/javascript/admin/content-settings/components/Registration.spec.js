import Vuex from "vuex";
import { shallowMount, createLocalVue } from "@vue/test-utils";

import mockStore from "admin/content-settings/store/__mocks__";
import Registration from "admin/content-settings/components/Registration";
import Icon from "components/Icon";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("Admin Content & Settings - Registration component", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(Registration, {
      localVue,
      store: mockStore.createMocks().store,
    });
  });

  it("has a name attribute", () => {
    expect(Registration.name).toEqual("registration-section");
  });

  describe("data", () => {
    it("contains the correct default data", () => {
      expect(Registration.data()).toEqual({
        checkboxes: {
          student: "Students",
          mentor: "Mentors",
          judge: "Judges",
        },
      });
    });
  });

  describe("markup", () => {
    it("contains the proper HTML based on data", () => {
      const studentCheckbox = wrapper.find("#season_toggles_student_signup");
      const studentCheckboxLabel = wrapper.find(
        'label[for="season_toggles_student_signup"]'
      );
      const mentorCheckbox = wrapper.find("#season_toggles_mentor_signup");
      const mentorCheckboxLabel = wrapper.find(
        'label[for="season_toggles_mentor_signup"]'
      );
      const judgeCheckbox = wrapper.find("#season_toggles_judge_signup");
      const judgeCheckboxLabel = wrapper.find(
        'label[for="season_toggles_judge_signup"]'
      );

      expect(wrapper.vm.judgingEnabled).toBe(false);

      expect(studentCheckbox.exists()).toBe(true);
      expect(studentCheckboxLabel.exists()).toBe(true);
      expect(mentorCheckbox.exists()).toBe(true);
      expect(mentorCheckboxLabel.exists()).toBe(true);
      expect(judgeCheckbox.exists()).toBe(true);
      expect(judgeCheckboxLabel.exists()).toBe(true);
    });

    it("disables checkboxes and sets values to 0 is judging is enabled", () => {
      wrapper = shallowMount(Registration, {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
          },
        }).store,
      });

      const studentCheckbox = wrapper.find("#season_toggles_student_signup");
      const studentCheckboxLabel = wrapper.find(
        'label[for="season_toggles_student_signup"]'
      );
      const mentorCheckbox = wrapper.find("#season_toggles_mentor_signup");
      const mentorCheckboxLabel = wrapper.find(
        'label[for="season_toggles_mentor_signup"]'
      );

      expect(wrapper.vm.judgingEnabled).toBe(true);

      expect(studentCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: "season_toggles_student_signup",
          type: "checkbox",
          disabled: "disabled",
          value: "0",
        })
      );

      expect(studentCheckboxLabel.attributes()).toEqual(
        expect.objectContaining({
          class: "label--disabled",
        })
      );

      expect(mentorCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: "season_toggles_mentor_signup",
          type: "checkbox",
          disabled: "disabled",
          value: "0",
        })
      );

      expect(mentorCheckboxLabel.attributes()).toEqual(
        expect.objectContaining({
          class: "label--disabled",
        })
      );
    });

    it("allows judge registraitons when juding is enabled", () => {
      wrapper = shallowMount(Registration, {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
            isSuperAdmin: () => {
              return true;
            },
          },
        }).store,
      });

      const judgeCheckbox = wrapper.find("#season_toggles_judge_signup");
      const judgeCheckboxLabel = wrapper.find(
        'label[for="season_toggles_judge_signup"]'
      );

      expect(wrapper.vm.judgingEnabled).toBe(true);

      expect(judgeCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: "season_toggles_judge_signup",
          type: "checkbox",
        })
      );

      expect(judgeCheckbox.attributes()).not.toEqual(
        expect.objectContaining({
          id: "season_toggles_judge_signup",
          type: "checkbox",
          disabled: "disabled",
        })
      );

      expect(judgeCheckboxLabel.attributes()).not.toEqual(
        expect.objectContaining({
          class: "label--disabled",
        })
      );
    });

    it("displays warning notices if judging is enabled", () => {
      wrapper = shallowMount(Registration, {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
          },
        }).store,
      });

      const notices = wrapper.findAll(".notice");

      expect(wrapper.vm.judgingEnabled).toBe(true);
      expect(notices.length).toEqual(2);
      notices.wrappers.forEach((notice) => {
        const props = notice.find(Icon).props();

        expect(props).toEqual(
          expect.objectContaining({
            name: "exclamation-circle",
            size: 16,
            color: "00529B",
          })
        );
      });
    });
  });
});
