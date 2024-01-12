import Vuex from "vuex";
import { shallowMount, createLocalVue } from "@vue/test-utils";

import mockStore from "admin/content-settings/store/__mocks__";
import TeamsAndSubmissions from "admin/content-settings/components/TeamsAndSubmissions";
import Icon from "components/Icon";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("Admin Content & Settings - TeamsAndSubmissions component", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(TeamsAndSubmissions, {
      localVue,
      store: mockStore.createMocks().store,
    });
  });

  it("has a name attribute", () => {
    expect(TeamsAndSubmissions.name).toEqual("teams-and-submissions-section");
  });

  describe("markup", () => {
    it("contains the proper HTML based on data", () => {
      const teamBuildingEnabledCheckbox = wrapper.find(
        "#season_toggles_team_building_enabled"
      );
      const teamBuildingEnabledCheckboxLabel = wrapper.find(
        'label[for="season_toggles_team_building_enabled"]'
      );
      const teamSubmissionsEditableCheckbox = wrapper.find(
        "#season_toggles_team_submissions_editable"
      );
      const teamSubmissionsEditableCheckboxLabel = wrapper.find(
        'label[for="season_toggles_team_submissions_editable"]'
      );

      expect(wrapper.vm.judgingEnabled).toBe(false);

      expect(teamBuildingEnabledCheckbox.exists()).toBe(true);
      expect(teamBuildingEnabledCheckboxLabel.exists()).toBe(true);
      expect(teamSubmissionsEditableCheckbox.exists()).toBe(true);
      expect(teamSubmissionsEditableCheckboxLabel.exists()).toBe(true);
    });

    it("disables checkboxes and sets values to 0 is judging is enabled", () => {
      wrapper = shallowMount(TeamsAndSubmissions, {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
          },
        }).store,
      });

      const teamBuildingEnabledCheckbox = wrapper.find(
        "#season_toggles_team_building_enabled"
      );
      const teamBuildingEnabledCheckboxLabel = wrapper.find(
        'label[for="season_toggles_team_building_enabled"]'
      );
      const teamSubmissionsEditableCheckbox = wrapper.find(
        "#season_toggles_team_submissions_editable"
      );
      const teamSubmissionsEditableCheckboxLabel = wrapper.find(
        'label[for="season_toggles_team_submissions_editable"]'
      );

      expect(wrapper.vm.judgingEnabled).toBe(true);

      expect(teamBuildingEnabledCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: "season_toggles_team_building_enabled",
          type: "checkbox",
          disabled: "disabled",
          value: "0",
        })
      );

      expect(teamBuildingEnabledCheckboxLabel.attributes()).toEqual(
        expect.objectContaining({
          class: "label--disabled",
        })
      );

      expect(teamSubmissionsEditableCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: "season_toggles_team_submissions_editable",
          type: "checkbox",
          disabled: "disabled",
          value: "0",
        })
      );

      expect(teamSubmissionsEditableCheckboxLabel.attributes()).toEqual(
        expect.objectContaining({
          class: "label--disabled",
        })
      );
    });

    it("displays warning notices if judging is enabled", () => {
      wrapper = shallowMount(TeamsAndSubmissions, {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
          },
        }).store,
      });

      expect(wrapper.vm.judgingEnabled).toBe(true);

      const notices = wrapper.findAll(".notice");

      expect(notices.length).toEqual(3);
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

