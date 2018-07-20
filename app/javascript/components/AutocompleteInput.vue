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
import autoComplete from '../../../vendor/assets/javascripts/auto-complete.min'

export default {
  name: 'autocomplete-input',

  data() {
    return {
      autoCompleteInstance: null,
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
    this.getSuggestionsDebounced = debounce((term, suggest) => {
      this.getSuggestions(term, suggest)
    })
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

      if (this.url !== '') {
        window.axios.get(this.url, {
          params: {
            q: query,
          },
        })
        .then((response) => {
          suggest(response.data.attributes)
        })
      } else {
        const matches = []
        for (let i = 0; i < this.options.length; i += 1) {
          if (this.options[i].toLowerCase().includes(query)) {
            matches.push(this.options[i])
          }
        }
        suggest(matches)
      }
    },
  },
}
</script>

<style scoped>
</style>