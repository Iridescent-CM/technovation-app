import Vue from 'vue'
import App from './App'
import VueFormulate from '@braid/vue-formulate'

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
        error: "text-red-700 text-xs mb-1"
    },
    slotComponents: {
        label: "HTMLAllowedCustomLabel"
    }
});

document.addEventListener('DOMContentLoaded', () => {
    console.log("new registration js");
    const app = new Vue({
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)
    console.log("test")
    console.log(app)
})