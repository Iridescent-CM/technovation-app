import Vue from 'vue'
import VueFormulate from '@braid/vue-formulate'

import App from './App'
import { verifyStudentAge, verifyMentorAge } from 'utilities/age-validations.js'

const htmlCustomLabelComponent = {
    props: ["context"],
    template: `
    <label
      :class="[context.classes.label, 'input-label-text']"
      :for="context.id"
      v-html="context.label"
    />
  `
};

Vue.component("HTMLAllowedCustomLabel", htmlCustomLabelComponent);

Vue.use(VueFormulate, {
    classes: {
        outer: "mb-4",
        // input: "border border-gray-400 rounded px-3 py-2 leading-none focus:border-green-500 outline-none border-box w-full mb-1",
        label: "font-medium text-sm",
        help: "text-xs mb-1 text-gray-600",
        error: ["text-red-700 text-xs mb-1", "validation-error-message"]
    },
    locales: {
        en: {
            studentAge ({args}) {
                const [division] = args

                if (division === 'beginner') {
                    return "A student must be 8-12 years old to participate in the beginners division."
                } else {
                    return "You must be 13-18 years old to participate as a student."
                }
            },
            mentorAge () {
                return "You must be at least 18 years old to participate as a mentor."
            }
        }
    },
    rules: {
        studentAge: ({value}, division) => verifyStudentAge({birthday: value, division}),
        mentorAge: ({value}) => verifyMentorAge({birthday: value})
    },
    slotComponents: {
        label: "HTMLAllowedCustomLabel"
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)
})
