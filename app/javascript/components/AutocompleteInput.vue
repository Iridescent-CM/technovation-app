<template>
  <div class="autocomplete-input">
    <input
      type="text"
      :name="name"
      :id="id"
    />
  </div>
</template>

<script>

import { debounce } from '../utilities/utilities'
import autoComplete from '../../../app/assets/javascripts/auto-complete'

export default {
  name: 'autocomplete-input',

  data() {
    return {
      autoCompleteInstance: null,
      mutableOptions: [],
    }
  },

  props: {
    name: {
      type: String,
      default: '',
    },

    id: {
      type: String,
      default: '',
    },

    url: {
      type: String,
      default: '',
    },

    options: {
      type: Array,
      default() {
        return []
      },
    },
  },

  created () {
    if (this.url !== '') {
      window.axios.get(this.url)
        .then((response) => {
          this.mutableOptions = response.data.attributes
        })
    } else {
      this.mutableOptions = this.options
    }

    this.getSuggestionsDebounced = debounce((term, suggest) => {
      this.getSuggestions(term, suggest)
    }, 250)
  },

  mounted () {
    this.initializeAutocomplete()
  },

  methods: {
    initializeAutocomplete () {
      if (
        this.autoCompleteInstance !== null
        && typeof this.autoCompleteInstance.destroy !== 'undefined'
      ) {
        this.autoCompleteInstance.destroy()
      }

      this.autoCompleteInstance = new autoComplete({
        selector: '.autocomplete-input > input',
        minChars: 2,
        source: (term, suggest) => {
          this.getSuggestionsDebounced(term, suggest)
        },
      })
    },

    getSuggestions (term, suggest) {
      const query = term.toLowerCase()

      const matches = []
      for (let i = 0; i < this.mutableOptions.length; i += 1) {
        if (this.mutableOptions[i].toLowerCase().includes(query)) {
          matches.push(this.mutableOptions[i])
        }
      }

      suggest(matches)
    },
  },
}
</script>

<style scoped>
</style>