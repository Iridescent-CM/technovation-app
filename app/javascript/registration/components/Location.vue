<template>
  <location-form
    :wizard-token="wizardToken"
    :scope-name="apiRoot"
    :handleBack="handleBack"
    :handleConfirm="handleConfirm"
    :showFinalCancel="false"
    :showBackBtn="true"
    v-model="locationData"
  ></location-form>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

import { debounce } from 'utilities/utilities'
import LocationForm from 'location/components/LocationForm'

const { mapState } = createNamespacedHelpers('registration')

export default {
  name: 'location',

  components: {
    LocationForm,
  },

  computed: {
    ...mapState(['wizardToken', 'apiRoot']),

    locationData: {
      get() {
        return this.$store.getters['registration/getLocation']
      },

      set(location) {
        this.$store.commit('registration/location', location)
      },
    },
  },

  methods: {
    handleBack () {
      this.$router.push({ name: 'data-use' })
    },

    handleConfirm () {
      this.$router.push({ name: 'age' })
    },
  },
}
</script>