import Vue from 'vue'

import JpTemplate from './template'

document.addEventListener('DOMContentLoaded', () => {
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
