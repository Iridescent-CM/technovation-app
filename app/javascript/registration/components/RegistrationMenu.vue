<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'data-use' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-enable="true"
      :condition-to-complete="termsAgreed"
    >
      Data agreement
      <span>{{ termsAgreedLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'location' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="termsNotAgreedMessage"
      :condition-to-enable="termsAgreed"
      :condition-to-complete="isLocationSet"
    >
      Region
      <span>{{ regionLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'age' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="termsNotAgreedMessage"
      :condition-to-enable="termsAgreed"
      :condition-to-complete="isAgeSet"
    >
      Date of birth / Age
      <span>{{ ageLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'choose-profile' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="chooseProfileDisabledMessage"
      :condition-to-enable="termsAgreed && isAgeSet"
      :condition-to-complete="isProfileChosen"
    >
      Choose profile
      <span>{{ profileChoice || "" | capitalize }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'basic-profile' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="basicProfileDisabledMessage"
      :condition-to-enable="termsAgreed && isAgeSet && isProfileChosen"
      :condition-to-complete="isBasicProfileSet"
    >
      Profile detail
      <span>{{ profileLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'login' }"
      :disabled-tooltip="loginDisabledMessage"
      :condition-to-enable="readyForAccount"
      v-if="!currentAccount"
    >
      Sign in
    </tab-link>

    <tab-link
      :to="{ name: 'change-email' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="true"
      v-if="currentAccount"
    >
      Change email
      <span>{{ currentAccount.email }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'change-password' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="true"
      v-if="currentAccount"
    >
      Change password
      <span>************</span>
    </tab-link>
  </ul>
</template>
<script>
import { createNamespacedHelpers } from 'vuex'

import TabLink from 'tabs/components/TabLink'

const { mapState, mapGetters } = createNamespacedHelpers('registration')
const { mapState: mapStudentState } = createNamespacedHelpers('student')

export default {
  name: 'registration-menu',

  components: {
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
      if (this.termsAgreed && this.termsAgreedDate)
        return `Agreed on ${this.termsAgreedDate}`

      return ''
    },

    ageLabel () {
      if (this.isAgeSet)
        return `${this.getAge()} years old`

      return ''
    },

    regionLabel () {
      if (this.isLocationSet)
        return Object.values(this.getLocation).join(', ')

      return ''
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
}
</script>

<style lang="scss" scoped>
</style>