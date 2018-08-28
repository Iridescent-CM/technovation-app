<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'data-use' }"
      css-classes="tabs__menu-link--has-subtitles"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(termsAgreed)"
        size="16"
        :color="$route.name === 'data-use' ? '000000' : '28A880'"
      />
      Data agreement
      <span>{{ termsAgreedLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'location' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="termsNotAgreedMessage"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(isLocationSet)"
        size="16"
        :color="activeEnabledOrDisabledColor('location', termsAgreed)"
      />
      Region
      <span>{{ regionLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'age' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="termsNotAgreedMessage"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(isAgeSet)"
        size="16"
        :color="activeEnabledOrDisabledColor('age', termsAgreed)"
      />
      Date of birth / Age
      <span>{{ ageLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'choose-profile' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="chooseProfileDisabledMessage"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(isProfileChosen)"
        size="16"
        :color="activeEnabledOrDisabledColor('choose-profile', (termsAgreed && isAgeSet))"
      />
      Choose profile
      <span>{{ profileChoice || "" | capitalize }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'basic-profile' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="basicProfileDisabledMessage"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(isBasicProfileSet)"
        size="16"
        :color="activeEnabledOrDisabledColor('basic-profile', (termsAgreed && isAgeSet && isProfileChosen))"
      />
      Profile detail
      <span>{{ profileLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'login' }"
      :disabled-tooltip="loginDisabledMessage"
      v-if="!currentAccount"
    >
      <icon
        name="circle-o"
        size="16"
        :color="activeEnabledOrDisabledColor('login', readyForAccount)"
      />
      Sign in
    </tab-link>

    <tab-link
      :to="{ name: 'change-email' }"
      css-classes="tabs__menu-link--has-subtitles"
      v-if="currentAccount"
    >
      Change email
      <span>{{ currentAccount.email }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'change-password' }"
      css-classes="tabs__menu-link--has-subtitles"
      v-if="currentAccount"
    >
      Change password
      <span>************</span>
    </tab-link>
  </ul>
</template>
<script>
import { createNamespacedHelpers } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

const { mapState, mapGetters } = createNamespacedHelpers('registration')
const { mapState: mapStudentState } = createNamespacedHelpers('student')

export default {
  name: 'registration-menu',

  components: {
    Icon,
    TabLink,
  },

  computed: {
    ...mapState([
      'termsAgreed',
      'termsAgreedDate',
      'profileChoice',
    ]),

    ...mapStudentState([
      'currentAccount',
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

    termsAgreedLabel () {
      if (this.termsAgreed) return `Agreed on ${this.termsAgreedDate}`
      return ''
    },

    ageLabel () {
      if (this.isAgeSet)
        return `${this.getAge()} years old`

      return ""
    },

    regionLabel () {
      if (this.isLocationSet)
        return Object.values(this.getLocation).join(', ')

      return ""
    },

    profileLabel () {
      return this.getFullName || ""
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

<style lang="scss" scoped>
</style>