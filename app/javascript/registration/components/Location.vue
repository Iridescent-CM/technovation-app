<template>
  <location-form
    scope-name="registration"
    :handleConfirm="handleConfirm"
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

    handleConfirm () {
      this.$router.push({ name: 'basic-profile' })
    },
  },

  watch: {
    locationData (newObj) {
      this.updateLocation(newObj)
    },
  },
}
</script>