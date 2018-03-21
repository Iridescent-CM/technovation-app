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
      juniorDivision: true,
      seniorDivision: true,
    }
  },

  watch: {
    juniorDivision (bool) {
      this.$store.commit('searchFilters', {
        name: 'division-junior',
        param: 'accounts_grid[division][]',
        value: bool ? 'junior' : '',
      })
    },

    seniorDivision (bool) {
      this.$store.commit('searchFilters', {
        name: 'division-senior',
        param: 'accounts_grid[division][]',
        value: bool ? 'senior' : '',
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
