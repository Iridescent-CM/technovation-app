import Vuex from "vuex";
import { shallowMount, createLocalVue, RouterLinkStub } from "@vue/test-utils";

import mockStore from "admin/content-settings/store/__mocks__";
import AdminContentSettings from "admin/content-settings/components/AdminContentSettings";
import Icon from "components/Icon";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("Admin Content & Settings - AdminContentSettings component", () => {
  let wrapper;

  function assertIconProps(icon) {
    expect(icon.props()).toEqual(
      expect.objectContaining({
        name: "exclamation-circle",
        size: 16,
        color: "D8000C",
      })
    );
  }

  beforeAll(() => {
    console.error = jest.fn(() => {});
  });

  beforeEach(() => {
    axios.mockResponseOnce("get", { data: { attributes: {} } });

    wrapper = shallowMount(AdminContentSettings, {
      localVue,
      store: mockStore.createMocks().store,
      stubs: {
        RouterLink: RouterLinkStub,
        "router-view": true,
      },
      propsData: {
        cancelButtonUrl: "/admin/dashboard",
      },
      computed: {
        currentRoute: jest.fn(() => {
          return "not-review";
        }),
      },
    });
  });

  it("has a name attribute", () => {
    expect(AdminContentSettings.name).toEqual("admin-content-settings");
  });

  it("starts out loading", () => {
    const myUncreatedWrapper = shallowMount(AdminContentSettings, {
      store: mockStore.createMocks().store,
      localVue,
      created() {
        // no op 'stub' for this test
      },
    });

    expect(myUncreatedWrapper.find(".loading").text()).toEqual("Loading...");
  });

  describe("props", () => {
    it("contains the correct props", () => {
      expect(AdminContentSettings.props).toEqual({
        cancelButtonUrl: {
          type: String,
          required: true,
        },
      });
    });
  });

  describe("created hook", () => {
    it("initializes settings state from remote data", (done) => {
      axios.mockResponseOnce("get", {
        data: {
          attributes: {
            student_signup: 1,
            student_dashboard_text: "Student dashboard text",
            mentor_dashboard_text: "Mentor dashboard text",
            judge_dashboard_text: "Judge dashboard text",
            chapter_ambassador_dashboard_text:
              "Chapter ambassador dashboard text",
            student_survey_link: {
              text: "Student Link",
              url: "http://google.com",
              long_desc: "This is a long description for student link",
            },
            mentor_survey_link: {
              text: "Mentor Link",
              url: "http://bing.com",
              long_desc: "This is a long description for mentor link",
            },
            team_building_enabled: 1,
            select_regional_pitch_event: 0,
            create_regional_pitch_event: 0,
            add_teams_to_regional_pitch_event: 0,
            judging_round: "qf",
            display_scores: 1,
          },
        },
      });

      wrapper = shallowMount(AdminContentSettings, {
        localVue,
        store: mockStore.createMocks().store,
        stubs: {
          RouterLink: RouterLinkStub,
          "router-view": true,
        },
        propsData: {
          cancelButtonUrl: "/admin/dashboard",
        },
        computed: {
          currentRoute: jest.fn(() => {
            return "not-review";
          }),
        },
      });

      setImmediate(() => {
        expect(wrapper.vm.isLoading).toBe(false);
        expect(wrapper.vm.$store.state).toEqual({
          is_super_admin: false,
          student_signup: 1,
          mentor_signup: 0,
          judge_signup: 0,
          chapter_ambassador_signup: 0,
          club_ambassador_signup: 0,
          student_dashboard_text: "Student dashboard text",
          mentor_dashboard_text: "Mentor dashboard text",
          judge_dashboard_text: "Judge dashboard text",
          chapter_ambassador_dashboard_text:
            "Chapter ambassador dashboard text",
          student_survey_link: {
            text: "Student Link",
            url: "http://google.com",
            long_desc: "This is a long description for student link",
          },
          mentor_survey_link: {
            text: "Mentor Link",
            url: "http://bing.com",
            long_desc: "This is a long description for mentor link",
          },
          team_building_enabled: 1,
          team_submissions_editable: 0,
          select_regional_pitch_event: 0,
          create_regional_pitch_event: 0,
          add_teams_to_regional_pitch_event: 0,
          judging_round: "qf",
          display_scores: 1,
        });
        done();
      });
    });
  });

  describe("methods", () => {
    describe("buildFormInputsMarkup", () => {
      it("builds input markup to submit form", () => {
        const formData = {
          student_signup: 1,
          mentor_signup: false,
          student_dashboard_text: "Student",
          mentor_dashboard_text: "Mentor",
          judge_dashboard_text: "Judge",
          chapter_ambassador_dashboard_text: "Chapter Ambassador",
          student_survey_link: {
            text: "Student Link",
            url: "http://google.com",
            long_desc: "This is a long student description",
          },
          mentor_survey_link: {
            text: "Mentor Link",
            url: "http://bing.com",
            long_desc: "This is a long mentor description",
          },
        };

        const testElement = document.createElement("div");
        testElement.innerHTML = wrapper.vm.buildFormInputsMarkup(formData);

        const inputs = testElement.querySelectorAll("input");

        expect(inputs[0].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[student_signup]" value="1">'
        );
        expect(inputs[1].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[mentor_signup]" value="0">'
        );
        expect(inputs[2].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[student_dashboard_text]" value="Student">'
        );
        expect(inputs[3].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[mentor_dashboard_text]" value="Mentor">'
        );
        expect(inputs[4].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[judge_dashboard_text]" value="Judge">'
        );
        expect(inputs[5].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[chapter_ambassador_dashboard_text]" value="Chapter Ambassador">'
        );
        expect(inputs[6].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[student_survey_link][text]" value="Student Link">'
        );
        expect(inputs[7].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[student_survey_link][url]" value="http://google.com">'
        );
        expect(inputs[8].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[student_survey_link][long_desc]" value="This is a long student description">'
        );
        expect(inputs[9].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[mentor_survey_link][text]" value="Mentor Link">'
        );
        expect(inputs[10].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[mentor_survey_link][url]" value="http://bing.com">'
        );
        expect(inputs[11].outerHTML).toEqual(
          '<input type="hidden" name="season_toggles[mentor_survey_link][long_desc]" value="This is a long mentor description">'
        );
      });
    });
  });

  describe("computed properties", () => {
    describe("formData", () => {
      it("returns an object used for populating form inputs based on dynamic data", () => {
        wrapper = shallowMount(AdminContentSettings, {
          localVue,
          store: mockStore.createMocks({
            state: {
              student_signup: 1,
              mentor_signup: 0,
              judge_signup: 0,
              chapter_ambassador_signup: 0,
              club_ambassador_signup: 0,
              student_dashboard_text: "Student",
              mentor_dashboard_text: "Mentor",
              judge_dashboard_text: "Judge",
              chapter_ambassador_dashboard_text: "Chapter Ambassador",
              student_survey_link: {
                text: "Student Link",
                url: "http://google.com",
                long_desc: "Student link long description",
              },
              mentor_survey_link: {
                text: "Mentor Link",
                url: "http://bing.com",
                long_desc: "Mentor link long description",
              },
              team_building_enabled: 1,
              team_submissions_editable: 0,
              select_regional_pitch_event: 1,
              create_regional_pitch_event: 1,
              add_teams_to_regional_pitch_event: 1,
              judging_round: "off",
              display_scores: 0,
            },
          }).store,
          stubs: {
            RouterLink: RouterLinkStub,
            "router-view": true,
          },
          propsData: {
            cancelButtonUrl: "/admin/dashboard",
          },
          computed: {
            currentRoute: jest.fn(() => {
              return "not-review";
            }),
          },
        });

        expect(wrapper.vm.formData).toEqual({
          student_signup: true,
          mentor_signup: false,
          judge_signup: false,
          chapter_ambassador_signup: false,
          club_ambassador_signup: false,
          student_dashboard_text: "Student",
          mentor_dashboard_text: "Mentor",
          judge_dashboard_text: "Judge",
          chapter_ambassador_dashboard_text: "Chapter Ambassador",
          student_survey_link: {
            text: "Student Link",
            url: "http://google.com",
            long_desc: "Student link long description",
          },
          mentor_survey_link: {
            text: "Mentor Link",
            url: "http://bing.com",
            long_desc: "Mentor link long description",
          },
          team_building_enabled: true,
          team_submissions_editable: false,
          select_regional_pitch_event: true,
          create_regional_pitch_event: true,
          add_teams_to_regional_pitch_event: true,
          judging_round: "off",
          display_scores: false,
        });
      });
    });
  });

  describe("HTML layout", () => {
    it("contains the tab grid layout", () => {
      expect(wrapper.find("#admin-content-settings").classes()).toEqual([
        "tabs",
        "tabs--vertical",
        "grid",
      ]);

      expect(wrapper.find("#admin-content-settings ul").classes()).toEqual([
        "tabs__menu",
        "grid__col-md-3",
      ]);

      expect(wrapper.find("router-view-stub").classes()).toEqual([
        "tabs__content",
        "grid__col-md-9",
      ]);

      const routerLinks = [
        "registrationLink",
        "noticesLink",
        "surveysLink",
        "teamsAndSubmissionsLink",
        "eventsLink",
        "judgingLink",
        "scoresAndCertificatesLink",
      ];

      routerLinks.forEach((ref) => {
        const link = wrapper.find({ ref });
        const props = link.props();
        const attributes = link.attributes();

        expect(props.tag).toBe("li");
        expect(props.activeClass).toBe("tabs__menu-link--active");
        expect(attributes.class).toBe("tabs__menu-link");

        expect(link.find('button[role="button"]').classes()).toEqual([
          "tabs__menu-button",
        ]);
      });

      const reviewLink = wrapper.find({ ref: "reviewLink" });
      const reviewLinkProps = reviewLink.props();

      expect(reviewLinkProps.tag).toBe("button");
      expect(reviewLinkProps.to).toEqual({ name: "review" });
      expect(reviewLink.attributes().class).toBe("button primary");

      const cancelButton = wrapper.find({ ref: "cancelButton" });
      const cancelButtonAttributes = cancelButton.attributes();

      expect(cancelButtonAttributes.href).toBe("/admin/dashboard");
    });

    it("displays warning icons on router links if judging is enabled", (done) => {
      wrapper = shallowMount(AdminContentSettings, {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
          },
          actions: {
            init: () => {
              return Promise.resolve({});
            },
          },
        }).store,
        stubs: {
          RouterLink: RouterLinkStub,
          "router-view": true,
        },
        propsData: {
          cancelButtonUrl: "/admin/dashboard",
        },
        computed: {
          currentRoute: jest.fn(() => {
            return "not-review";
          }),
        },
      });

      setImmediate(() => {
        expect(wrapper.vm.judgingEnabled).toBe(true);
        expect(wrapper.vm.isLoading).toBe(false);
        expect(wrapper.vm.hasError).toBe(false);

        const registrationLink = wrapper.find({ ref: "registrationLink" });
        assertIconProps(registrationLink.find(Icon));

        const noticesLink = wrapper.find({ ref: "noticesLink" });
        expect(noticesLink.find(Icon).exists()).toBe(false);

        const surveysLink = wrapper.find({ ref: "surveysLink" });
        expect(surveysLink.find(Icon).exists()).toBe(false);

        const teamsAndSubmissionsLink = wrapper.find({
          ref: "teamsAndSubmissionsLink",
        });
        assertIconProps(teamsAndSubmissionsLink.find(Icon));

        const eventsLink = wrapper.find({ ref: "eventsLink" });
        assertIconProps(eventsLink.find(Icon));

        const judgingLink = wrapper.find({ ref: "judgingLink" });
        expect(judgingLink.find(Icon).exists()).toBe(false);

        const scoresAndCertificatesLink = wrapper.find({
          ref: "scoresAndCertificatesLink",
        });
        assertIconProps(scoresAndCertificatesLink.find(Icon));

        done();
      });
    });

    it("displays save button if on review page", (done) => {
      const properties = {
        localVue,
        store: mockStore.createMocks({
          getters: {
            judgingEnabled: () => {
              return true;
            },
          },
          actions: {
            init: () => {
              return Promise.resolve({});
            },
          },
        }).store,
        stubs: {
          RouterLink: RouterLinkStub,
          "router-view": true,
        },
        propsData: {
          cancelButtonUrl: "/admin/dashboard",
        },
      };

      wrapper = shallowMount(
        AdminContentSettings,
        Object.assign({}, properties, {
          computed: {
            currentRoute: jest.fn(() => {
              return "not-review";
            }),
          },
        })
      );

      setImmediate(() => {
        let reviewLink = wrapper.find({ ref: "reviewLink" });
        let submitButton = wrapper.find({ ref: "submitButton" });

        expect(reviewLink.exists()).toBe(true);
        expect(submitButton.exists()).toBe(false);

        done();
      });
    });

    it("displays review router link otherwise", (done) => {
      const properties = {
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
          actions: {
            init: () => {
              return Promise.resolve({});
            },
          },
        }).store,
        stubs: {
          RouterLink: RouterLinkStub,
          "router-view": true,
        },
        propsData: {
          cancelButtonUrl: "/admin/dashboard",
        },
      };

      wrapper = shallowMount(
        AdminContentSettings,
        Object.assign({}, properties, {
          computed: {
            currentRoute: jest.fn(() => {
              return "review";
            }),
          },
        })
      );

      setImmediate(() => {
        let reviewLink = wrapper.find({ ref: "reviewLink" });
        let submitButton = wrapper.find({ ref: "submitButton" });

        expect(reviewLink.exists()).toBe(false);
        expect(submitButton.exists()).toBe(true);

        done();
      });
    });
  });
});
