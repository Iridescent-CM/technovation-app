<template>
  <location-form
    scope-name="registration"
    :handleBack="handleBack"
    :handleConfirm="handleConfirm"
    :showFinalCancel="false"
    v-model="locationData"
  ></location-form>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import LocationForm from 'location/components/LocationForm'

export default {
  name: 'location',

  components: {
    LocationForm,
  },

  data () {
    return {
      locationData: {
        city: "",
        state: "",
        country: "",
      },
    }
  },

  created () {
    this.locationData = this.getLocation()
  },

  methods: {
    ...mapGetters(['getLocation']),
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

      if (locationChanged) this.updateLocation(newLocation)
    },
  },
}
</script>