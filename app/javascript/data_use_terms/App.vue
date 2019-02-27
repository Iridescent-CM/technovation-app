<template>
  <div class="grid">
    <div class="grid__col-12">
      <data-use-terms
        :handle-submit="handleSubmit"
        submit-button-text="Submit"
      ></data-use-terms>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

import DataUseTerms from 'registration/components/DataUseTerms';

const { mapState } = createNamespacedHelpers('registration');

export default {
  name: 'app',

  components: {
    DataUseTerms,
  },

  computed: {
    ...mapState([
      'isReady',
    ]),
  },

  methods: {
    handleSubmit () {
      window.location.href = '/';
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
