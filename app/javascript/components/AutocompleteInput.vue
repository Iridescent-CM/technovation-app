<template>
  <div class="autocomplete-input">
    <input
      type="hidden"
      :name="name"
      :value="mutableValue"
    />
    <vue-select
      :input-id="id"
      :options="mutableOptions"
      v-model="mutableValue"
      taggable
    >
      <template slot="no-options">
        {{ noOptionsText }}
      </template>
    </vue-select>
  </div>
</template>

<script>

import VueSelect from 'vue-select'

export default {
  name: 'autocomplete-input',

  components: {
    VueSelect,
  },

  data() {
    return {
      autoCompleteInstance: null,
      mutableOptions: [],
      mutableValue: null,
    }
  },

  props: {
    id: {
      type: String,
      default: '',
    },

    name: {
      type: String,
      default: '',
    },

    noOptionsText: {
      type: String,
      default: '',
    },

    options: {
      type: Array,
      default() {
        return []
      },
    },

    url: {
      type: String,
      default: '',
    },

    value: {
      type: String,
      default: '',
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

    if (this.value.length) {
      this.mutableValue = this.value
    }
  },
}
</script>

<style scoped>
</style>