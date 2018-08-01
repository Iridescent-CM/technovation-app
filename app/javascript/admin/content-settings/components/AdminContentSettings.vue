<template>
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

      <router-link
        ref="reviewLink"
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'review' }"
      >
        <button role="button" class="tabs__menu-button">
          Review
        </button>
      </router-link>
    </ul>

    <router-view class="tabs__content grid__col-md-9"></router-view>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'

import Icon from 'components/Icon'

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

    formData: {
      type: Object,
      default () {
        return {}
      },
    }
  },

  created () {
    this.setCancelButtonUrl(this.cancelButtonUrl)
    this.setFormData(this.formData)
  },

  methods: {
    ...mapMutations([
      'setFormData',
      'setCancelButtonUrl',
    ]),
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
    ]),
  },
}
</script>

<style scoped>
</style>