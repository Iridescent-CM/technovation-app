// Module imports
import Vue from "vue";
import { shallowMount } from "@vue/test-utils";

// Mocked module imports
import axios from "axios";

// Mock vue-dragula dependency so we don't break our component
Vue.directive("dragula", (el, binding) => {});
window.vueDragula = {
  eventBus: new Vue(),
};

import ScreenshotUploader from "components/ScreenshotUploader";

describe.skip("ScreenshotUploader Vue component", () => {
  const screenshot = {
    id: 1,
    src: "https://s3.amazonaws.com/technovation-uploads-dev/1.png",
    name: null,
    large_img_url:
      "https://s3.amazonaws.com/technovation-uploads-dev/large_1.png",
  };

  const screenshotTwo = {
    id: 2,
    src: "https://s3.amazonaws.com/technovation-uploads-dev/2.png",
    name: null,
    large_img_url:
      "https://s3.amazonaws.com/technovation-uploads-dev/large_2.png",
  };

  let wrapper;

  beforeEach(() => {
    axios.get.mockClear();
    axios.post.mockClear();
    axios.patch.mockClear();

    // Mock out the screenshot repopulation AJAX call before each test
    axios.mockResponse("get", [screenshot, screenshotTwo]);

    wrapper = shallowMount(ScreenshotUploader, {
      propsData: {
        screenshotsUrl: "/student/screenshots",
        sortUrl: "/student/team_submissions/no-name-yet-by-all-star-team",
        teamId: 1,
      },
    });
  });

  describe("data", () => {
    it("returns an object with the proper initialization", () => {
      expect(ScreenshotUploader.data()).toEqual({
        maxAllowed: 6,
        screenshots: [],
        uploads: [],
        uploadsHaveErrors: false,
      });
    });
  });

  describe("props", () => {
    it("contains valid sortUrl, screenshotsUrl, and teamId properties", () => {
      expect(ScreenshotUploader.props).toEqual({
        sortUrl: {
          type: String,
          required: true,
        },

        screenshotsUrl: {
          type: String,
          required: true,
        },

        teamId: {
          type: Number,
          required: true,
        },
      });
    });
  });

  describe("mounted lifecycle hook", () => {
    beforeAll(() => {
      jest.useFakeTimers();
    });

    it("loads the previously saved screenshots via AJAX", (done) => {
      axios.get.mockClear();

      expect(axios.get).not.toHaveBeenCalled();

      wrapper = shallowMount(ScreenshotUploader, {
        propsData: {
          screenshotsUrl: "/student/screenshots",
          sortUrl: "/student/team_submissions/no-name-yet-by-all-star-team",
          teamId: 1,
        },
      });

      expect(axios.get).toHaveBeenCalledWith(
        `${wrapper.vm.screenshotsUrl}?team_id=${wrapper.vm.teamId}`
      );

      wrapper.vm.$nextTick(() => {
        expect(wrapper.vm.screenshots).toEqual([screenshot, screenshotTwo]);
        done();
      });
    });

    it("sets up VueDragula drop event handler", (done) => {
      wrapper.vm.$nextTick(() => {
        const vueDragulaArgs = [
          "globalBag",
          wrapper.find("li.sortable-list__item.draggable:first-child").element,
          wrapper.find(
            "ol#sortable-list.sortable-list.submission-pieces__screenshots"
          ).element,
          wrapper.find(
            "ol#sortable-list.sortable-list.submission-pieces__screenshots"
          ).element,
          wrapper.find("li.sortable-list__item.draggable:last-child").element,
        ];

        window.vueDragula.eventBus.$emit("drop", vueDragulaArgs);

        wrapper.vm.$nextTick(() => {
          const form = new FormData();

          form.append(
            "team_submission[screenshots][]",
            vueDragulaArgs[1].dataset.dbId
          );

          form.append(
            "team_submission[screenshots][]",
            vueDragulaArgs[4].dataset.dbId
          );

          form.append("team_id", wrapper.vm.teamId);

          expect(axios.patch).toHaveBeenCalledWith(wrapper.vm.sortUrl, form);

          expect(vueDragulaArgs[1].classList).toContain(
            "sortable-list--updated"
          );

          jest.advanceTimersByTime(1000);

          expect(vueDragulaArgs[1].classList).not.toContain(
            "sortable-list--updated"
          );

          done();
        });
      });
    });
  });

  describe("computed properties", () => {
    describe("maxFiles", () => {
      it("returns the the number of screenshots remaining for upload", () => {
        const nextIndex = wrapper.vm.screenshots.length + 1;

        for (let i = nextIndex; i <= wrapper.vm.maxAllowed; i += 1) {
          wrapper.vm.screenshots.push({
            id: i,
            src: `https://s3.amazonaws.com/technovation-uploads-dev/${i}.png`,
            name: null,
            large_img_url: `https://s3.amazonaws.com/technovation-uploads-dev/large_${i}.png`,
          });

          expect(wrapper.vm.maxFiles).toEqual(wrapper.vm.maxAllowed - i);
        }
      });
    });

    describe("object", () => {
      it('returns "screenshots" if more than one file upload remains', () => {
        expect(wrapper.vm.maxFiles).toBeGreaterThan(1);
        expect(wrapper.vm.object).toEqual("images");
      });

      it('returns "screenshot" if only one file upload remains', () => {
        wrapper = shallowMount(ScreenshotUploader, {
          propsData: {
            screenshotsUrl: "/student/screenshots",
            sortUrl: "/student/team_submissions/no-name-yet-by-all-star-team",
            teamId: 1,
          },
          computed: {
            maxFiles() {
              return 1;
            },
          },
        });

        expect(wrapper.vm.object).toEqual("image");
      });
    });

    describe("prefix", () => {
      it('returns "up to" if more than one file upload remains', () => {
        expect(wrapper.vm.maxFiles).toBeGreaterThan(1);
        expect(wrapper.vm.prefix).toEqual("up to");
      });

      it('returns "" if only one file upload remains', () => {
        wrapper = shallowMount(ScreenshotUploader, {
          propsData: {
            screenshotsUrl: "/student/screenshots",
            sortUrl: "/student/team_submissions/no-name-yet-by-all-star-team",
            teamId: 1,
          },
          computed: {
            maxFiles() {
              return 1;
            },
          },
        });

        expect(wrapper.vm.prefix).toEqual("");
      });
    });
  });

  describe("methods", () => {
    describe("removeScreenshot", () => {
      beforeAll(() => {
        window.swal = jest.fn();

        window.swal.mockImplementation(() => {
          return Promise.resolve({ value: true });
        });
      });

      afterAll(() => {
        window.swal.mockRestore();
      });

      it("calls swal with the correct settings", () => {
        wrapper.vm.removeScreenshot(screenshot);

        expect(swal).toHaveBeenCalledWith({
          text: "Are you sure you want to delete the image?",
          cancelButtonText: "No, go back",
          confirmButtonText: "Yes, delete it",
          confirmButtonColor: "#D8000C",
          showCancelButton: true,
          reverseButtons: true,
          focusCancel: true,
        });
      });

      it("removes the screenshot from the screenshots array when alert is confirmed", (done) => {
        expect(wrapper.vm.screenshots).toHaveLength(2);
        expect(wrapper.vm.screenshots).toContain(screenshot);
        expect(wrapper.vm.screenshots).toContain(screenshotTwo);

        wrapper.vm.removeScreenshot(screenshot);

        setImmediate(() => {
          expect(wrapper.vm.screenshots).toHaveLength(1);
          expect(wrapper.vm.screenshots).not.toContain(screenshot);
          expect(wrapper.vm.screenshots).toContain(screenshotTwo);
          done();
        });
      });

      it("removes the screenshot from the database via AJAX call when alert is confirmed", (done) => {
        axios.delete.mockClear();

        wrapper.vm.removeScreenshot(screenshot);

        setImmediate(() => {
          expect(axios.delete).toHaveBeenCalledWith(
            wrapper.vm.screenshotsUrl +
              `/${screenshot.id}?team_id=${wrapper.vm.teamId}`
          );
          done();
        });
      });
    });

    describe("handleFileInput", () => {
      const firstImage = new File(
        [""],
        "Screen Shot 2018-06-04 at 4.30.00 PM.png",
        { type: "image/png" }
      );

      const secondImage = new File(
        [""],
        "Screen Shot 2018-06-04 at 5.00.00 PM.png",
        { type: "image/png" }
      );

      let fileUploadEventMock;

      beforeEach(() => {
        fileUploadEventMock = {
          target: {
            files: [firstImage, secondImage],
            value: "Screen Shot 2018-06-04 at 4.30.00 PM.png",
          },
        };
      });

      it("adds the file input images to the uploads array", (done) => {
        // Mock .then() for axios.post calls so that we can test state
        // before AJAX is complete and promise resolved
        axios.post.mockImplementation(() => {
          return {
            then: () => {},
          };
        });

        wrapper.vm.handleFileInput(fileUploadEventMock);

        setImmediate(() => {
          expect(wrapper.vm.uploads).toEqual([firstImage, secondImage]);
          done();
        });
      });

      it("calls AJAX with the correct parameters", (done) => {
        wrapper.vm.handleFileInput(fileUploadEventMock);

        setImmediate(() => {
          expect(axios.post).toHaveBeenCalledTimes(2);

          const imageFiles = [firstImage, secondImage];

          imageFiles.forEach((file) => {
            const form = new FormData();

            form.append("team_submission[screenshots_attributes][]image", file);
            form.append("team_id", wrapper.vm.teamId);

            expect(axios.post).toHaveBeenCalledWith(
              wrapper.vm.screenshotsUrl,
              form
            );
          });

          done();
        });
      });

      describe("AJAX success callback", () => {
        // Please note that these tests will become cleaner once we pull the
        // success callback out of the actual AJAX call
        beforeEach(() => {
          wrapper.vm.screenshots = [];
          axios.mockResponseOnce("post", screenshot);
          axios.mockResponseOnce("post", screenshotTwo);
        });

        it("adds each image object to the screenshots array", (done) => {
          expect(wrapper.vm.screenshots).toHaveLength(0);

          wrapper.vm.handleFileInput(fileUploadEventMock);

          setImmediate(() => {
            expect(axios.post).toHaveBeenCalledTimes(2);

            expect(wrapper.vm.screenshots).toEqual([screenshot, screenshotTwo]);

            done();
          });
        });

        it("removes each file object from the uploads array", (done) => {
          wrapper.vm.handleFileInput(fileUploadEventMock);

          setImmediate(() => {
            expect(wrapper.vm.uploads).toHaveLength(0);

            done();
          });
        });

        it('sets the file input element value to ""', (done) => {
          expect(fileUploadEventMock.target.value).toEqual(
            "Screen Shot 2018-06-04 at 4.30.00 PM.png"
          );

          wrapper.vm.handleFileInput(fileUploadEventMock);

          setImmediate(() => {
            expect(fileUploadEventMock.target.value).toEqual("");
            done();
          });
        });
      });
    });
  });
});
