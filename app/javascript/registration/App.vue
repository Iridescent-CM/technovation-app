<template>
  <div class="grid tabs tabs--vertical tabs--remove-bg tabs--css-only">
    <ul class="grid__col-3 tabs__menu">
      <tab-link
        :to="{ name: 'data-use' }"
      >
        <icon
          :name="termsAgreed ? 'check-circle-o' : 'circle-o'"
          size="16"
          :color="$route.name === 'data-use' ? '28A880' : '000000'"
        />
        {{ termsAgreed ? 'Terms agreed' : 'Data agreement' }}
      </tab-link>

      <tab-link
        :to="{ name: 'location' }"
        :disabled-tooltip="termsNotAgreedMessage"
      >
        <icon
          :name="isLocationSet ? 'check-circle-o' : 'circle-o'"
          size="16"
          :color="$route.name === 'location' ? '28A880' : '000000'"
        />
        {{ regionLabel }}
      </tab-link>

      <tab-link
        :to="{ name: 'age' }"
        :disabled-tooltip="termsNotAgreedMessage"
      >
        <icon
          :name="isAgeSet ? 'check-circle-o' : 'circle-o'"
          size="16"
          :color="$route.name === 'age' ? '28A880' : '000000'"
        />
        {{ ageLabel }}
      </tab-link>

      <tab-link
        :to="{ name: 'choose-profile' }"
        :disabled-tooltip="chooseProfileDisabledMessage"
      >
        <icon
          :name="isProfileChosen ? 'check-circle-o' : 'circle-o'"
          size="16"
          :color="$route.name === 'choose-profile' ? '28A880' : '000000'"
        />
        {{ profileChoice || "Choose Profile" | capitalize }}
      </tab-link>

      <tab-link
        :to="{ name: 'basic-profile' }"
        :disabled-tooltip="basicProfileDisabledMessage"
      >
        <icon
          :name="isBasicProfileSet ? 'check-circle-o' : 'circle-o'"
          size="16"
          :color="$route.name === 'basic-profile' ? '28A880' : '000000'"
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
          :color="$route.name === 'login' ? '28A880' : '000000'"
        />
        Sign in
      </tab-link>
    </ul>

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
}
</script>