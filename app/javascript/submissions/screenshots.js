import Vue from 'vue/dist/vue.common'
import VueDragula from 'vue-dragula';

Vue.use(VueDragula)

import ScreenshotUploader from '../components/ScreenshotUploader'

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('vue-screenshot-uploader') !== null) {
    new Vue({
      el: '#vue-screenshot-uploader',

      components: {
        ScreenshotUploader,
      },
    })
  }
})