<template>
  <div class="grid tabs tabs--vertical tabs--remove-bg tabs--css-only">
    <div class="grid__col-3 col--sticky-parent">
      <div class="col--sticky-spacer">
        <ul class="tabs__menu col--sticky">
          <tab-link
            :to="{ name: 'data-use' }"
          >
            <icon
              :name="completedEnabledOrDisabledIcon(termsAgreed)"
              size="16"
              :color="$route.name === 'data-use' ? '000000' : '28A880'"
            />
            {{ termsAgreed ? 'Terms agreed' : 'Data agreement' }}
          </tab-link>

          <tab-link
            :to="{ name: 'location' }"
            :disabled-tooltip="termsNotAgreedMessage"
          >
            <icon
              :name="completedEnabledOrDisabledIcon(isLocationSet)"
              size="16"
              :color="activeEnabledOrDisabledColor('location', termsAgreed)"
            />
            {{ regionLabel }}
          </tab-link>

          <tab-link
            :to="{ name: 'age' }"
            :disabled-tooltip="termsNotAgreedMessage"
          >
            <icon
              :name="completedEnabledOrDisabledIcon(isAgeSet)"
              size="16"
              :color="activeEnabledOrDisabledColor('age', termsAgreed)"
            />
            {{ ageLabel }}
          </tab-link>

          <tab-link
            :to="{ name: 'choose-profile' }"
            :disabled-tooltip="chooseProfileDisabledMessage"
          >
            <icon
              :name="completedEnabledOrDisabledIcon(isProfileChosen)"
              size="16"
              :color="activeEnabledOrDisabledColor('choose-profile', (termsAgreed && isAgeSet))"
            />
            {{ profileChoice || "Choose Profile" | capitalize }}
          </tab-link>

          <tab-link
            :to="{ name: 'basic-profile' }"
            :disabled-tooltip="basicProfileDisabledMessage"
          >
            <icon
              :name="completedEnabledOrDisabledIcon(isBasicProfileSet)"
              size="16"
              :color="activeEnabledOrDisabledColor('basic-profile', (termsAgreed && isAgeSet && isProfileChosen))"
            />
            {{ profileLabel }}
          </tab-link>

          <tab-link
            :to="{ name: 'login' }"
            :disabled-tooltip="loginDisabledMessage"
          >
            <icon
              name="circle-o"
              size="16"
              :color="activeEnabledOrDisabledColor('login', readyForAccount)"
            />
            Sign in
          </tab-link>
        </ul>
      </div>
    </div>

    <div class="grid__col-9">
      <transition name="router-fade">
        <router-view v-if="isReady"></router-view>
      </transition>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

export default {
  name: 'app',

  components: {
    Icon,
    TabLink,
  },

  computed: {
    ...mapState([
      'isReady',
      'termsAgreed',
      'profileChoice',
    ]),

    ...mapGetters([
      'isAgeSet',
      'getAge',
      'isProfileChosen',
      'isBasicProfileSet',
      'isLocationSet',
      'getLocation',
      'readyForAccount',
      'getFullName',
    ]),

    ageLabel () {
      if (this.isAgeSet)
        return `${this.getAge()} years old`

      return "Date of Birth"
    },

    regionLabel () {
      if (this.isLocationSet)
        return Object.values(this.getLocation).join(', ')

      return "Set Region"
    },

    profileLabel () {
      return this.getFullName || "Setup Profile"
    },

    termsNotAgreedMessage () {
      if (!this.termsAgreed)
        return 'You must agree to the data use terms to continue'

      return ''
    },

    ageNotSetMessage () {
      if (!this.isAgeSet)
        return 'Please fill out your date of birth first'

      return ''
    },

    chooseProfileDisabledMessage () {
      if (this.termsNotAgreedMessage !== '')
        return this.termsNotAgreedMessage

      if (!this.isAgeSet)
        return this.ageNotSetMessage

      return ''
    },

    basicProfileDisabledMessage () {
      if (this.termsNotAgreedMessage !== '')
        return this.termsNotAgreedMessage

      if (!this.isAgeSet)
        return this.ageNotSetMessage

      if (!this.profileChoice)
        return 'Please choose a profile first'

      return ''
    },

    loginDisabledMessage () {
      if (!this.readyForAccount)
        return 'Please fill out other sections first'

      return ''
    },
  },

  mounted () {
    if (jQuery)
      $(".col--sticky").stick_in_parent({
        parent: ".col--sticky-parent",
        spacer: ".col--sticky-spacer",
        recalc_every: 1,
      })
  },

  methods: {
    completedEnabledOrDisabledIcon (conditionToComplete) {
      if (conditionToComplete)
        return 'check-circle'

      return 'circle-o'
    },

    activeEnabledOrDisabledColor (routeName, conditionToEnable) {
      if (this.$route.name === routeName)
        return '000000'

      if (conditionToEnable)
        return '28A880'

      return '999999'
    },
  },
}
</script>