<template>
  <div class="grid tabs tabs--vertical tabs--remove-bg tabs--css-only">
    <ul class="grid__col-3 tabs__menu">
      <tab-link :to="{ name: 'data-use' }">Data agreement</tab-link>
      <tab-link :to="{ name: 'age' }">Date of Birth</tab-link>
      <tab-link :to="{ name: 'location' }">Region</tab-link>
      <tab-link :to="{ name: 'basic-profile' }">Basic Profile</tab-link>
      <tab-link :to="{ name: 'login' }">Logging in</tab-link>
    </ul>

    <router-view
      v-if="isReady"
      class="grid__col-9"
    ></router-view>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import TabLink from '../tabs/components/TabLink'

export default {
  name: 'app',

  components: {
    TabLink,
  },

  data () {
    return {
      isReady: false,
    }
  },

  props: {
    previousAttempt: {
      type: String,
      required: false,
      default: null
    },
  },

  created() {
    if (this.previousAttempt) {
      this.initWizard({ previousAttempt: this.previousAttempt })
      this.isReady = true
    } else {
      this.isReady = true
    }
  },

  methods: mapActions(['initWizard']),
}
</script>