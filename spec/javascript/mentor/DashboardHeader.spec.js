import "axios";
import { shallowMount, createLocalVue } from "@vue/test-utils";
import Vuex from "vuex";

import mockStore from "mentor/store/__mocks__";
import DashboardHeader from "mentor/DashboardHeader";
import DropDown from "components/DropDown";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("mentor/DashboardHeader.vue", () => {
  let defaultWrapper;

  beforeEach(() => {
    const defaultStore = mockStore.createMocks();

    defaultWrapper = shallowMount(DashboardHeader, {
      localVue,
      store: new Vuex.Store({
        modules: {
          authenticated: {
            namespaced: true,
            state: defaultStore.state,
            getters: defaultStore.getters,
            mutations: defaultStore.mutations,
          },
        },
      }),
    });
  });

  it("contains the two headers", () => {
    expect(
      defaultWrapper.findAll(".dashboard-notices .grid__col-sm-6").length
    ).toEqual(2);
  });

  it("contains the resources drop-down", () => {
    const dropDowns = defaultWrapper.findAllComponents(DropDown);

    const resourceDropDown = dropDowns.at(1);
    expect(resourceDropDown.exists()).toBe(true);
    expect(resourceDropDown.vm.label).toEqual("Helpful Links");
  });

  it("contains the more details drop-down", () => {
    const dropDowns = defaultWrapper.findAllComponents(DropDown);

    const resourceDropDown = dropDowns.at(0);
    expect(resourceDropDown.exists()).toBe(true);
    expect(resourceDropDown.vm.label).toEqual("More Details");
  });

  it("displays the currentAccount's name", async () => {
    defaultWrapper.vm.$store.commit("authenticated/htmlDataset", {
      currentAccount: '{"data":{"attributes":{"name":"Saul Goodman"}}}',
    });

    await defaultWrapper.vm.$nextTick();

    expect(
      defaultWrapper
        .find(".dashboard-notices .grid__col-sm-6:nth-child(2)")
        .text()
    ).toContain("Saul Goodman");
  });

  // todo: UPDATE THIS TEST
  xdescribe("when the chapter ambassador has not provided an intro", () => {
    it("displays the default left header", async () => {
      defaultWrapper.setProps({
        defaultTitle: "Mentor Dashboard",
        resourceLinks: [
          {
            url: "something",
            text: "something",
            isSurveyLink: true,
          },
        ],
      });

      await defaultWrapper.vm.$nextTick();

      expect(
        defaultWrapper
          .find(".dashboard-notices .grid__col-sm-6:first-child")
          .text()
      ).toContain("Mentor Dashboard");

      expect(
        defaultWrapper
          .find(".dashboard-notices .grid__col-sm-6:first-child h1 small a")
          .exists()
      ).toBe(true);
    });
  });

  describe("when the mentor is assigned to a chapter ", () => {
    beforeEach(() => {
      defaultWrapper.vm.$store.commit("authenticated/htmlDataset", {
        currentAccount:
          '{"data":{"attributes":{"chapterName":"Technovation[MN]","assignedToChapter":"true"}}}',
        chapterAmbassador:
          '{"data":{"attributes":{"avatarUrl":"https://cdn.filestackcontent.com/MeWCyN4LQzWrojqPwYDX}"}}}',
      });
    });

    it("displays the chapter ambassador intro header", () => {
      const text = defaultWrapper
        .find(".dashboard-notices .grid__col-sm-6:first-child")
        .text();

      expect(text).toContain("Technovation[MN]");
    });
  });
});
