<template>
  <location-form
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

const { mapActions, mapState } = createNamespacedHelpers('registration')

export default {
  name: 'location',

  components: {
    LocationForm,
  },

  created() {
    this.debouncedLocationUpdate = debounce(newLocation => {
      this.updateLocation(newLocation)
    }, 500)
  },

  computed: {
    ...mapState(['apiRoot']),

    locationData: {
      get() {
        return this.$store.getters.getLocation
      },

      set(location) {
        this.$store.commit('registration/location', location)
      },
    },
  },

  methods: {
    ...mapActions(['updateLocation']),

    handleBack () {
      this.$router.push({ name: 'data-use' })
    },

    handleConfirm () {
      this.$router.push({ name: 'age' })
    },
  },

  watch: {
    locationData (newLocation, oldLocation) {
      const locationChanged = Object.keys(newLocation).some((key) => {
        return newLocation[key] !== oldLocation[key]
      })

      if (locationChanged) this.debouncedLocationUpdate(newLocation)
    },
  },
}
</script>