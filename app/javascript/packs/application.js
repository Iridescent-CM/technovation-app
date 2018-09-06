/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'

import AutocompleteInput from 'components/AutocompleteInput'
import CertificateButton from 'components/CertificateButton'
import LocationForm from '../location/components/LocationForm'

Vue.use(TurbolinksAdapter)

import '../config/axios'
import '../registration'

document.addEventListener('turbolinks:load', function () {
  const buttonElems = document.querySelectorAll('.vue-enable-certificate-btn')

  for (let i = 0; i < buttonElems.length; i += 1) {
    new Vue({
      el: buttonElems[i],

      components: {
        CertificateButton,
      },
    })
  }

  const locationFormElems = document.querySelectorAll('.vue-enable-location-form')

  for (let i = 0; i < locationFormElems.length; i += 1) {
    new Vue({
      el: locationFormElems[i],

      components: {
        LocationForm,
      },
    })
  }

  const autocompleteInputs = document.querySelectorAll('.vue-enable-autocomplete-input')

  for (let i = 0; i < autocompleteInputs.length; i += 1) {
    new Vue({
      el: autocompleteInputs[i],

      components: {
        AutocompleteInput,
      },
    })
  }
})