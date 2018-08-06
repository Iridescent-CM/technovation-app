<template>
  <div class="grid tabs tabs--vertical tabs--remove-bg tabs--css-only">
    <ul class="grid__col-3 tabs__menu">
      <tab-link
        :to="{ name: 'data-use' }"
      >Data agreement</tab-link>

      <tab-link
        :to="{ name: 'age' }"
        :disabled-tooltip="termsNotAgreedMessage"
      >Date of Birth</tab-link>

      <tab-link
        :to="{ name: 'location' }"
        :disabled-tooltip="termsNotAgreedMessage"
      >Region</tab-link>

      <tab-link
        :to="{ name: 'basic-profile' }"
        :disabled-tooltip="termsNotAgreedMessage"
      >Basic Profile</tab-link>

      <tab-link
        :to="{ name: 'login' }"
        :disabled-tooltip="loginDisabledMessage"
      >Logging in</tab-link>
    </ul>

    <router-view
      v-if="isReady"
      class="grid__col-9"
    ></router-view>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import TabLink from '../tabs/components/TabLink'

export default {
  name: 'app',

  components: {
    TabLink,
  },

  computed: {
    ...mapState([
      'isReady',
      'termsAgreed'
    ]),

    ...mapGetters(['readyForAccount']),

    termsNotAgreedMessage () {
      if (!this.termsAgreed) {
        return 'You must agree to the data use terms to continue'
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