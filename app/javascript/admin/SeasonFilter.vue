<template>
  <div>
    <v-subheader>Seasons</v-subheader>

    <v-select
      label="Select"
      :items="seasons"
      v-model="selected"
      multiple
      chips
      deletable-chips
      hint="Choose seasons"
      persistent-hint
      ></v-select>
  </div>
</template>

<script>
export default {
  name: 'SeasonFilter',

  data () {
    return {
      seasons: this.$store.getters.searchFilters({
        name: 'seasons',
      }),

      selected: this.$store.getters.searchFilters({
        name: 'selectedSeasons',
      }),
    }
  },

  watch: {
    selected (collection) {
      this.$store.commit('searchFilters', {
        filterRoot: 'seasons',
        value: collection
      })
    },
  },

  props: [],

  components: {
  },

  methods: {
  },

  mounted () {
    console.log('season filter')
  },
}
</script>
