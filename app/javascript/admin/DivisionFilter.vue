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

  computed: {
    divisions () {
      return [
        this.juniorDivision ? 'junior' : '',
        this.seniorDivision ? 'senior' : ''
      ]
    },
  },

  watch: {
    divisions (collection) {
      this.$store.commit('searchFilters', {
        name: 'division',
        param: 'accounts_grid[division][]',
        value: collection,
        multiple: true,
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
