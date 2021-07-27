import Vue from 'vue'

import store from './store'
import { router } from './routes'

import ScoreStepper from './ScoreStepper'

document.addEventListener('DOMContentLoaded', () => {
  const stepperEl = document.querySelector('#judge-scores-stepper')

  if (stepperEl != undefined) {
    new Vue({
      el: stepperEl,
      router,
      store,

      template: '<ScoreStepper />',

      components: {
        ScoreStepper,
      },
    })
  }
})
