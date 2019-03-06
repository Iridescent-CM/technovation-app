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

import { airbrake } from 'utilities/utilities'
import DataUseTerms from 'registration/components/DataUseTerms';

const { mapState } = createNamespacedHelpers('registration');

export default {
  name: 'app',

  components: {
    DataUseTerms,
  },

  computed: {
    ...mapState([
      'termsAgreed',
      'email'
    ]),
  },

  methods: {
    handleSubmit () {
      const updateEndpoint = '/terms_agreement';

      axios.patch(updateEndpoint, {
        termsAgreed: this.termsAgreed,
        email: this.email,
      })
        .catch((error) => {
          airbrake.notify({
            error,
            params: {
              url: updateEndpoint,
              termsAgreed: this.termsAgreed,
              email: this.email,
            },
          });
        })
        .then(() => {
          window.location.href = '/';
        });
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
