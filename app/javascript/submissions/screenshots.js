import Vue from 'vue/dist/vue.common'
import VueDragula from 'vue-dragula';

Vue.use(VueDragula)

import ScreenshotUploader from '../components/ScreenshotUploader'

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('vue-screenshot-uploader') !== null) {
    // We have to assign the VueDragula event bus to a global level variable in
    // order to communicate with sub components.
    window.vueDragula = Vue.vueDragula

    new Vue({
      el: '#vue-screenshot-uploader',

      components: {
        ScreenshotUploader,
      },
    })
  }
})