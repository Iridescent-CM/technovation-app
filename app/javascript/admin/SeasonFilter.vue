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
import _ from 'lodash'

export default {
  name: 'SeasonFilter',

  data () {
    return {
      seasons: [2018, 2017, 2016, 2015],
      selected: [2018],
    }
  },

  computed: {
  },

  watch: {
    selected (collection) {
      this.$store.commit('searchFilters', {
        name: 'season',
        param: 'accounts_grid[season][]',
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
