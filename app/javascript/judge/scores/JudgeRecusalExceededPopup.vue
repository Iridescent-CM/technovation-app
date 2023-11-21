<template>
  <a href="#" @click.prevent="openAlertMessage" :class="cssClass">
    <slot></slot>
  </a>
</template>

<script>
import Swal from 'sweetalert2'

export default {
  props: {
    cssClass: {
      type: String,
      default: ''
    }
  },

  methods: {
    openAlertMessage () {
      Swal.fire({
        html: `
        <p>A judge may only recuse themselves from ${process.env.JUDGE_MAXIMUM_NUMBER_OF_RECUSALS} submissions.</p>

        <p>Please contact <a href=mailto:"${process.env.HELP_EMAIL}" class="tw-link-magenta">${process.env.HELP_EMAIL}</a> with any questions.</p>
        `,
        confirmButtonText: 'OK',
        confirmButtonColor: '#3FA428',
        width: '50%'
      })
    }
  }
}
</script>

<style lang="scss">
.swal2-content, .swal2-actions {
  width: 100%;
}

.swal2-content p {
  font-size: 1.1em;
  font-weight: bold;
  margin-bottom: 1rem;
}

.swal2-actions button.swal2-confirm {
  margin-top: 0.5rem;
  margin-bottom: 1rem;
  font-weight: bold;
}
</style>
