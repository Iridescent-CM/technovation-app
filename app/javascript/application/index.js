import Vue from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.use(TurbolinksAdapter)

import '../application/sticky-header';

import { urlHelpers } from 'utilities/utilities';

import AutocompleteInput from 'components/AutocompleteInput';
import CertificateButton from 'components/CertificateButton';
import LocationForm from '../location/components/LocationForm';

import '../terms_agreement';

document.addEventListener('turbolinks:load', function () {
  const buttonElems = document.querySelectorAll('.vue-enable-certificate-btn');

  for (let i = 0; i < buttonElems.length; i += 1) {
    new Vue({
      el: buttonElems[i],

      components: {
        CertificateButton,
      },
    });
  }

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

  const autocompleteInputs = document.querySelectorAll('.vue-enable-autocomplete-input');

  for (let i = 0; i < autocompleteInputs.length; i += 1) {
    new Vue({
      el: autocompleteInputs[i],

      components: {
        AutocompleteInput,
      },
    });
  }
});