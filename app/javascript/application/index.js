import Vue from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.use(TurbolinksAdapter)

import '../application/sticky-header';

import { urlHelpers } from 'utilities/utilities';

import LocationForm from '../location/components/LocationForm';

import '../terms_agreement';

document.addEventListener('turbolinks:load', function () {
  const locationFormElems = document.querySelectorAll('.vue-enable-location-form');

  for (let i = 0; i < locationFormElems.length; i += 1) {
    new Vue({
      el: locationFormElems[i],

      components: {
        LocationForm,
      },

      methods: {
        goBack() {
          const returnTo = urlHelpers.fetchGetParameterValue('return_to');
          if (!!returnTo) {
            window.location.href = returnTo;
          } else {
            window.history.back();
          }
        },
      },
    });
  }
});