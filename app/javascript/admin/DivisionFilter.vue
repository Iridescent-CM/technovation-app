<template>
  <div>
    <v-subheader>Divisions</v-subheader>

    <v-switch
      label="Junior"
      v-model="juniorDivision"
      ></v-switch>

    <v-switch
      label="Senior"
      v-model="seniorDivision"
      ></v-switch>
  </div>
</template>

<script>
export default {
  name: 'DivisionFilter',

  data () {
    return {
      juniorDivision: this.$store.getters.searchFilters({
        name: 'division',
        value: 'junior'
      }),

      seniorDivision: this.$store.getters.searchFilters({
        name: 'division',
        value: 'senior'
      }),
    }
  },

  watch: {
    juniorDivision (bool) {
      this.$store.commit('searchFilters', {
        filterRoot: 'division',
        filterName: 'junior',
        value: bool
      })
    },

    seniorDivision (bool) {
      this.$store.commit('searchFilters', {
        filterRoot: 'division',
        filterName: 'senior',
        value: bool
      })
    },
  },

  props: [],

  components: {
  },

  methods: {
  },

  mounted () {
  },
}
</script>
