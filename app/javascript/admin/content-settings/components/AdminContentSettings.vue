<template>
  <div v-if="isLoading" class="loading">
    Loading...
  </div>

  <div v-else-if="hasError" class="error">
    Error. Please let the dev team know.
  </div>

  <div v-else>
    <div class="tabs tabs--vertical grid" id="admin-content-settings">
      <ul class="tabs__menu grid__col-md-3">
        <router-link
          ref="registrationLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'registration' }"
        >
          <button role="button" class="tabs__menu-button">
            <icon
              v-if="judgingEnabled"
              name="exclamation-circle"
              :size="16"
              color="D8000C"
            />
            Registration
          </button>
        </router-link>

        <router-link
          ref="noticesLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'notices' }"
        >
          <button role="button" class="tabs__menu-button">
            Notices
          </button>
        </router-link>

        <router-link
          ref="surveysLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'surveys' }"
        >
          <button role="button" class="tabs__menu-button">
            Surveys
          </button>
        </router-link>

        <router-link
          ref="teamsAndSubmissionsLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'teams_and_submissions' }"
        >
          <button role="button" class="tabs__menu-button">
            <icon
              v-if="judgingEnabled"
              name="exclamation-circle"
              :size="16"
              color="D8000C"
            />
            Teams &amp; Submissions
          </button>
        </router-link>

        <router-link
          ref="eventsLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'events' }"
        >
          <button role="button" class="tabs__menu-button">
            <icon
              v-if="judgingEnabled"
              name="exclamation-circle"
              :size="16"
              color="D8000C"
            />
            Events
          </button>
        </router-link>

        <router-link
          ref="judgingLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'judging' }"
        >
          <button role="button" class="tabs__menu-button">
            Judging
          </button>
        </router-link>

        <router-link
          ref="scoresAndCertificatesLink"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
          :to="{ name: 'scores_and_certificates' }"
        >
          <button role="button" class="tabs__menu-button">
            <icon
              v-if="judgingEnabled"
              name="exclamation-circle"
              :size="16"
              color="D8000C"
            />
            Scores &amp; Certificates
          </button>
        </router-link>
      </ul>

      <router-view class="tabs__content grid__col-md-9"></router-view>
    </div>

    <div class="margin--t-large text-align--right">
      <router-link
        v-if="this.currentRoute !== 'review'"
        ref="reviewLink"
        tag="button"
        class="button primary"
        :to="{ name: 'review' }"
      >Review</router-link>
      <button
        v-else-if="isSuperAdmin"
        ref="submitButton"
        type="submit"
        class="button primary"
        @click.prevent="isProduction() ? confirmSaveSettings() : saveSettings()"
      >Save these settings</button>
      <a
        ref="cancelButton"
        class="button secondary"
        :href="cancelButtonUrl"
      >Cancel</a>
    </div>

    <div ref="formData"></div>
  </div>
</template>

<script>
import Swal from 'sweetalert2'
import { mapGetters, mapMutations } from 'vuex'

import Icon from 'components/Icon'
import { isProduction } from '../../../utilities/utilities'

export default {
  name: 'admin-content-settings',

  components: {
    Icon,
  },

  props: {
    cancelButtonUrl: {
      type: String,
      required: true,
    },
  },

  created () {
    this.$store.dispatch("init").then(() => {
      this.isLoading = false
    }).catch((err) => {
      console.error(err)
      this.isLoading = false
      this.hasError = true
    })
  },

  data () {
    return {
      isLoading: true,
      hasError: false
    }
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
      'formData',
      'isSuperAdmin'
    ]),

    currentRoute() {
      return this.$route.name
    },
  },

  methods: {
    isProduction,

    saveSettings () {
      this.$refs.formData.innerHTML = this.buildFormInputsMarkup(this.formData)
      document.getElementById('season_schedule').submit()
    },

    confirmSaveSettings () {
      Swal.fire({
        title: 'PRODUCTION SETTINGS',
        html: 'You are about to update settings on Production!<br>Are you sure you want to continue?',
        background: '#fecaca',
        confirmButtonText: 'Yes, save settings',
        confirmButtonColor: '#28A880',
        showCancelButton: true,
        focusCancel: true,
      }).then((result) => {
        if (result.isConfirmed) {
         this.saveSettings();
        }
      })
    },

    buildFormInputsMarkup (formData, prefix = 'season_toggles') {
      let markup = ''

      Object.keys(formData).forEach((key) => {
        const inputName = `${prefix}[${key}]`
        let inputValue

        if (formData[key] === false) {
          inputValue = 0
        } else if (formData[key] === true) {
          inputValue = 1
        } else {
          inputValue = formData[key]
        }

        if (inputValue !== null && typeof inputValue === 'object') {
          markup += this.buildFormInputsMarkup(inputValue, inputName)
        } else {
          inputValue = String(inputValue).replace(/"/g, '&quot;')
          markup += `
            <input
              type="hidden"
              name="${inputName}"
              value="${inputValue}"
            />`
        }
      })

      return markup
    },
  },
}
</script>

<style scoped>
</style>
