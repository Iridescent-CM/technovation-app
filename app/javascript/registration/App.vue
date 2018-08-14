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
        Data agreement
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
        Region
      </tab-link>

      <tab-link
        :to="{ name: 'age' }"
        :disabled-tooltip="termsNotAgreedMessage"
      >
        <icon
          :name="(isAgeSet && !!profileChoice) ? 'check-circle-o' : 'circle-o'"
          size="16"
          :color="$route.name === 'age' ? '28A880' : '000000'"
        />
        Date of Birth
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
        Region
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
        Setup Profile
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
      'isBasicProfileSet',
      'isLocationSet',
      'readyForAccount',
    ]),

    termsNotAgreedMessage () {
      if (!this.termsAgreed) {
        return 'You must agree to the data use terms to continue'
      }

      return ''
    },

    basicProfileDisabledMessage () {
      if (this.termsNotAgreedMessage !== '') {
        return this.termsNotAgreedMessage
      } else if (!this.isAgeSet || !this.profileChoice) {
        return 'Please fill out your date of birth first'
      }

      return ''
    },

    loginDisabledMessage () {
      if (!this.readyForAccount) {
        return 'Please fill out other sections first'
      }

      return ''
    },
  },
}
</script>