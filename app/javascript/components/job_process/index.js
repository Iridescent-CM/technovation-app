import Vue from 'vue/dist/vue.esm'

import JpTemplate from './template'

document.addEventListener('turbolinks:load', () => {
  const el = document.querySelector("#job-process-app")

  if (el != undefined) {
    new Vue({
      el: el,
      components: {
        JpTemplate,
      },
    })
  }
})