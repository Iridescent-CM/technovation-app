import Vue from "vue";
import VueFormulate from "@braid/vue-formulate";

import App from "./App";
import CustomLabel from "./components/CustomLabel";
import {
  verifyStudentAge,
  verifyOlderThanEighteen,
} from "utilities/age-helpers.js";

Vue.component("CustomLabel", CustomLabel);

Vue.use(VueFormulate, {
  classes: {
    outer: "mb-4",
    // input: "border border-gray-400 rounded-sm px-3 py-2 leading-none focus:border-green-500 outline-hidden border-box w-full mb-1",
    label: "font-medium text-sm",
    help: "text-xs mb-1 text-gray-600",
    error: ["text-red-700 text-xs mb-1", "validation-error-message"],
  },
  locales: {
    en: {
      studentAge({ args }) {
        const [division] = args;

        if (division === "beginner") {
          return "Students ages 13 to 18 by the cutoff date can register themselves. Please return to the first screen and select the 13 to 18 option if the student is older than 12.";
        } else {
          return "You must be 13-18 years old by the cutoff date to register yourself as a student. Please return to the previous screen and have a parent or guardian register you if you are under 13.";
        }
      },
      mentorAge() {
        return "You must be at least 18 years old to participate as a mentor.";
      },
      judgeAge() {
        return "You must be at least 18 years old to participate as a judge.";
      },
      chapterAmbassadorAge() {
        return "You must be at least 18 years old to participate as a chapter ambassador.";
      },
    },
  },
  rules: {
    studentAge: ({ value }, division) =>
      verifyStudentAge({ birthday: value, division }),
    mentorAge: ({ value }) => verifyOlderThanEighteen({ birthday: value }),
    judgeAge: ({ value }) => verifyOlderThanEighteen({ birthday: value }),
    chapterAmbassadorAge: ({ value }) => verifyOlderThanEighteen({ birthday: value }),
  },
  slotComponents: {
    label: "CustomLabel",
  },
});

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    render: (h) => h(App),
  }).$mount();
  document.body.appendChild(app.$el);
});
