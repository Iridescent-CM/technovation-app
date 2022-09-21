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
      :disabled-tooltip="Tooltips.MUST_AGREE_TERMS"
      :condition-to-enable="termsAgreed"
      :condition-to-complete="isLocationSet"
    >
      Region
      <span>{{ regionLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'age' }"
      css-classes="tabs__menu-link--has-subtitles"
      :disabled-tooltip="Tooltips.MUST_AGREE_TERMS"
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
      :to="{ name: 'login' }"
      :disabled-tooltip="Tooltips.MUST_FILL_OTHER_SECTIONS"
      :condition-to-enable="readyForAccount"
      v-if="!currentAccount"
    >
      Sign in
    </tab-link>

    <tab-link
      :to="{ name: 'change-email' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="true"
      :condition-to-enable="true"
      v-if="currentAccount"
    >
      Change email
      <span>{{ currentAccount.email }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'change-password' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="true"
      :condition-to-enable="true"
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
const { mapState: mapAuthState } = createNamespacedHelpers('authenticated')

const Tooltips = {
  MUST_AGREE_TERMS:         'You must agree to the data use terms to continue',
  MUST_SET_AGE:             'Please fill out your date of birth first',
  MUST_CHOOSE_PROFILE:      'Please choose a profile first',
  MUST_FILL_OTHER_SECTIONS: 'Please fill out other sections first',
}

export default {
  name: 'dashboard-menu',

  components: {
    TabLink,
  },

  created () {
    this.Tooltips = Tooltips
  },

  computed: {
    ...mapState([
      'termsAgreed',
      'termsAgreedDate',
      'profileChoice',
    ]),

    ...mapAuthState([
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

    chooseProfileDisabledMessage () {
      if (!this.termsAgreed)
        return Tooltips.MUST_AGREE_TERMS

      if (!this.isAgeSet)
        return Tooltips.MUST_SET_AGE

      return ''
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
